# Ezkey Demo Device — Agent Notes (standalone repo)

Public standalone copy of the Demo Device module from the main Ezkey repository. Spring Boot app simulating a mobile device for Auth API enrollment and MFA flows. Calls Auth API via **WebClient**; persists enrollments as JSON files under `data/enrollments/`.

**Sync policy:** Occasional port from `ezkey/ezkey-demo-device` on the private monorepo (Java `src/`, `openapi-spec.json`, OpenAPI/Maven hygiene). Keep this repo's Docker/start scripts, README, and Exp1 `.env.example` as standalone-only additions.

## QR `authUrl` routing (mobile parity)

When an Admin UI enrollment QR includes `authUrl`, the demo device routes **bind**, **verify**, **pending**, and **respond** for that enrollment to that base URL. The validated URL is persisted in `EnrollmentStoreService.Record.enrollmentUrl`.

| Entry path | Auth API base used | Persisted `enrollmentUrl` |
|------------|-------------------|---------------------------|
| QR with valid `authUrl` | QR URL | QR URL |
| QR without `authUrl` (pipe format) | `ezkey.auth.api.url` | null |
| Manual ID + token only | `ezkey.auth.api.url` | null |
| Later ops (verify, auth) | stored `enrollmentUrl` or config default | unchanged |

- Client: `enrollment-qr-import.js` populates hidden form field `authApiBaseUrl`.
- Server: `EnrollmentAuthApiUrlResolver` + `AuthApiUrlValidator` (mirrors mobile `urlValidation.ts`).
- Invalid non-blank QR URL → hard error (no silent fallback to config).

Standalone Docker default remains Exp1 (`https://exp1-auth-api.ezkey.org`); QR local enrollments override without `.env` change.

## Jackson 3 posture (Boot 4)

Ezkey uses the **Jackson 3 engine** with **FasterXML annotations** unchanged ([JSTEP-1](https://github.com/FasterXML/jackson-future-ideas/wiki/JSTEP-1)):

| Layer | Package | Demo-device usage |
|-------|---------|-------------------|
| Engine (`ObjectMapper`, serializers) | `tools.jackson.databind` | `EnrollmentStoreService`, tests |
| Annotations (`@JsonProperty`, `@JsonInclude`, …) | `com.fasterxml.jackson.annotation` | `EnrollmentStoreService.Record`, OpenAPI-generated DTOs |

Do **not** migrate annotations to `tools.jackson.annotation` — that namespace does not exist by design.

- **No** explicit `com.fasterxml.jackson.databind` or `jackson-datatype-jsr310` dependencies in this module.
- **OpenAPI generator** (`openapi-generator-maven-plugin`, `java` + `resttemplate`): models only (`generateApis=false`, `generateSupportingFiles=false`, `addCompileSourceRoot=false`). Compile path is scoped to `generated/dto` via build-helper. DTOs use `com.fasterxml.jackson.annotation`; HTTP JSON uses Spring Boot 4 WebClient codecs (Jackson 3).
- **`openApiNullable=false`** — no `jackson-databind-nullable` dependency.

## Regression anchor

`EnrollmentStoreRecordJsonRoundtripTest` guards enrollment file JSON field naming and round-trip. Run after mapper or `Record` changes:

```bash
mvn test -Dtest=EnrollmentStoreRecordJsonRoundtripTest
```

## OpenAPI models

- Spec: `openapi-spec.json` (generated Auth API snapshot; refresh via monorepo `scripts/update-specs.sh` when authorized).
- Generated package: `org.ezkey.demodevice.generated.dto`.
- Hand-written HTTP: `AuthApiService` (WebClient + generated DTOs).

## Running

**Docker (Exp1 / demos):** `./start.sh` or `start.cmd` — http://localhost:3080. Default Auth API: `https://exp1-auth-api.ezkey.org` (override via `.env`; see `.env.example`). QR `authUrl` overrides this default per enrollment without `.env` change.

**Local JDK:** `mvn clean install` then `java -jar target/ezkey-demo-device-0.1.0-SNAPSHOT.jar`.
