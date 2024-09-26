task :default => [:usage]
task :help => [:usage]
task :b => [:multiarch_build]
task :build => [:multiarch_build]
task :buildx => [:multiarch_build]

CONTAINER_NAME = 'unixorn/cupsd'

task :usage do
  puts 'Usage:'
  puts
  puts 'rake build:      Create the image'
  puts 'rake lint:       Lint Dockerfile with hadolint'
  puts
end

# Tasks

desc 'Use buildx to make a multi-arch container without cache'
task :cacheless do
  puts "Building #{CONTAINER_NAME}"
  sh %{ docker buildx build --no-cache --platform linux/amd64,linux/arm/v7,linux/arm64 --push -t #{CONTAINER_NAME} .}
  sh %{ docker pull #{CONTAINER_NAME} }
end

desc 'Use buildx to make a multi-arch container'
task :multiarch_build do
  puts "Building #{CONTAINER_NAME}"
  sh %{ docker buildx build --platform linux/amd64,linux/arm/v7,linux/arm64 --push -t #{CONTAINER_NAME} .}
  sh %{ docker pull #{CONTAINER_NAME} }
end

desc 'Buildx a local multiarch container'
task :local_multiarch_build do
  puts "Building #{CONTAINER_NAME}"
  sh %{ docker buildx build --platform linux/amd64,linux/arm/v7,linux/arm64 --load -t #{CONTAINER_NAME} .}
end

desc 'Lint the Dockerfile'
task :lint do
  sh %{ docker run --rm -i hadolint/hadolint < Dockerfile }
end

desc 'Build a quick test image'
task :test do
  sh %{ docker buildx build --platform linux/amd64 --load -t #{CONTAINER_NAME}:test .}
end

desc 'Small test image'
task :slim do
  sh %{ docker buildx build --build-arg ROOT_PASSWORD=zimbabwe --load -t #{CONTAINER_NAME}-slim . -f Dockerfile.slim}
end