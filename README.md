# Ezkey Demo Device

Standalone Spring Boot app: the **Demo Device** virtual phone for Ezkey. Use it to demo device-side enrollment and authentication against a running Ezkey **Auth API**.

## Run with Docker only (recommended for demos)

**Prerequisite:** [Docker](https://docs.docker.com/get-docker/) (Compose v2). No JDK or Maven required on the host; the image is built inside Docker with **BuildKit** and a Maven cache mount (same idea as the main Ezkey repo).

From the repository root, use whichever launcher you prefer:

| Shell | Command |
| --- | --- |
| Command Prompt | `start` or `start.cmd` |
| Batch | `start.bat` |
| PowerShell | `.\start.ps1` (optional: `-Detach` for background, `-NoCache` to force a clean build) |
| Git Bash / Unix | `./start.sh` (optional: `-d` for detached) |

This maps the app to **http://localhost:3080** (container listens on 8083 internally).

Without a `.env` file, Compose defaults to **http://host.docker.internal:8080** (Auth API on your host). The checked-in **`.env.example`** targets the **Exp1** Auth API (**https://exp1-auth-api.ezkey.org**); copy it to `.env` to use that stack, or set `EZKEY_AUTH_API_URL` / export it before Compose.

Stop (foreground run): `Ctrl+C`. If you started detached (`-Detach` / `-d`), run: `docker compose down`.

## Run locally (JDK + Maven)

**Prerequisites:** JDK 25, Maven 3.9+.

### Build

```bash
mvn clean install
```

### Run

```bash
java -jar target/ezkey-demo-device-0.1.0-SNAPSHOT.jar
```

Default HTTP port: **8083**. Point the app at your Auth API base URL (default in `application.properties` is `http://localhost:8080`).

Override via environment variable:

```bash
export EZKEY_AUTH_API_URL=http://localhost:8080
java -jar target/ezkey-demo-device-0.1.0-SNAPSHOT.jar
```

Or set `ezkey.auth.api.url` in `src/main/resources/application.properties` / an external config file.

## License

MIT — see [LICENSE](LICENSE).
