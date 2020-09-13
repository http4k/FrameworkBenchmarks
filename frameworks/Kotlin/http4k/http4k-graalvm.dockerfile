FROM gradle:6.6.0-jdk11
USER root
WORKDIR /http4k
COPY build.gradle build.gradle
COPY settings.gradle settings.gradle
COPY core core
COPY graalvm graalvm
RUN gradle --quiet graalvm:shadowJar

FROM oracle/graalvm-ce:20.2.0-java11 as graalvm
RUN gu install native-image

COPY . /home/app/http4k-example
WORKDIR /home/app/http4k-example
RUN ls graalvm/build/libs
RUN native-image  --allow-incomplete-classpath --no-fallback --no-server -cp graalvm/build/libs/http4k-graalvm-benchmark.jar Http4kGraalVmServerKt

FROM frolvlad/alpine-glibc
RUN apk update && apk add libstdc++
EXPOSE 8080
COPY --from=graalvm /home/app/http4k-example/http4kgraalvmserverkt /app/http4k-benchmark
ENTRYPOINT ["/app/http4k-benchmark"]
