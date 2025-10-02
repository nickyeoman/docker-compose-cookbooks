# Video Duplicate Finder

A Dockerized GUI tool for finding duplicate video files.  
This image is provided by [jlesage/video-duplicate-finder](https://hub.docker.com/r/jlesage/video-duplicate-finder), which packages the open-source [Video Duplicate Finder](https://github.com/0x90d/videoduplicatefinder).

---

## Links

- [Video Duplicate Finder (GitHub)](https://github.com/0x90d/videoduplicatefinder)
- [Docker Hub: jlesage/video-duplicate-finder](https://hub.docker.com/r/jlesage/video-duplicate-finder)

---

## Usage

The container requires a **storage directory**, which is where the application will search for video files.  
You can mount this to the current working directory (recommended for one-off runs) or to a specific folder on your system.

### Example: Run in current directory
This will launch the app and scan files in the current directory (`$(pwd)`):

```bash
docker run -d --name DuplicateFinder -p 5800:5800 -v "$(pwd)":/storage:rw jlesage/video-duplicate-finder:latest
```