# Ezkey Demo Device — moved

**This repository is retired and archived.** It no longer works with the current Ezkey Auth API:
the enrollment invitation no longer carries an enrollment ID, and the default Auth host here is
retired.

The Demo Device now lives only in the Ezkey monorepo:
**[github.com/mgagp/ezkey/tree/main/ezkey-demo-device](https://github.com/mgagp/ezkey/tree/main/ezkey-demo-device)**

To run it on its own against the community instance (`ezkey.online`), Docker only:

```bash
git clone https://github.com/mgagp/ezkey.git
cd ezkey
docker compose -f ezkey-demo-device/docker-compose.yml up --build
```

Then open http://localhost:3080/phone/ezkey. With the clean-start stack, the Demo Device already
runs on http://localhost:8083.

Why: [mgagp/ezkey#943](https://github.com/mgagp/ezkey/issues/943) (one source instead of a manual
two-repository sync). The previous contents remain in this repository's history.
