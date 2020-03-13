# Docker Image for TSN-Ranksystem
https://github.com/Newcomer1989/TSN-Ranksystem

# Build
```
docker build --build-arg VERSION=1.3.7 . -t tsn-ranksystem:1.3.7
```

# Usage
You can take the `docker-compose.yml` as an example and adopt it to your needs. For that to work you need to create an `.env` file based on the `.env.example` and fill it with the details you desire.

# Known issues
* TLS is not properly detected. Even if you add a TLS terminating proxy, the process in the container itself runs without SSL and TSN-Ranksystem can't detect it via X-Forwarded-Proto header yet (v1.3.7)
