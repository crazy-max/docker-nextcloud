variable "DEFAULT_TAG" {
  default = "nextcloud:local"
}

variable "DOCKERFILE" {
  default = "Dockerfile-21"
}

// Special target: https://github.com/crazy-max/ghaction-docker-meta#bake-definition
target "ghaction-docker-meta" {
  tags = ["${DEFAULT_TAG}"]
}

// Default target if none specified
group "default" {
  targets = ["image-local"]
}

target "dockerfile" {
  dockerfile = DOCKERFILE
}

target "image" {
  inherits = ["dockerfile", "ghaction-docker-meta"]
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm/v6",
    "linux/arm/v7",
    "linux/arm64",
    "linux/386",
    "linux/ppc64le",
    "linux/s390x"
  ]
}
