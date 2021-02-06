task :default => [:usage]
task :help => [:usage]
task :build => [:multiarch_build]
task :b => [:multiarch_build]

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

desc 'Lint the Dockerfile'
task :lint do
  sh %{ docker run --rm -i hadolint/hadolint < Dockerfile }
end
