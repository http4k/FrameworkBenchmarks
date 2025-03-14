plugins {
    id("nu.studer.rocker") version "3.0.4"
    id("java")
}

dependencies {
    api(platform("org.http4k:http4k-bom:6.1.0.1"))
    api("org.jetbrains.kotlin:kotlin-reflect:2.1.10")
    api("org.http4k:http4k-core")
    api("org.http4k:http4k-format-argo")
    api("org.http4k:http4k-template-rocker")
    api("org.apache.commons:commons-lang3:3.14.0")
    api("org.cache2k:cache2k-core:2.6.1.Final")

    compileOnly("com.fizzed:rocker-compiler:1.4.0")
}

rocker {
    version.set("1.3.0")
    configurations {
        create("main") {
            templateDir.set(file("src/main/resources"))
            outputDir.set(file("src/main/generated/kotlin"))
            classDir.set(file("out/main/classes"))
            extendsModelClass.set("org.http4k.template.RockerViewModel")
        }
    }
}

