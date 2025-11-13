import java.nio.file.Paths

val ACBrProjectName: String by rootProject.extra
val ACBrFolder: String by rootProject.extra
val ACBrDependenciesFolder: String by rootProject.extra
val ACBrLibFolder: String by rootProject.extra
val jniLibsFolder: String by rootProject.extra
val jniLibsFolder_arm64: String by rootProject.extra
val jniLibsFolder_armeabi: String by rootProject.extra
val jniLibsFolder_x86: String by rootProject.extra
val jniLibsFolder_x86_64: String by rootProject.extra
val isDemo : Boolean = project.hasProperty("Demo")
val isRequiredLibXML2 = rootProject.hasProperty("isRequiredLibXML2")


// variavel que indica uso de libs da familia x86 (uso restrito a emuladores)
val isRequiredLibsX86Family = rootProject.hasProperty("isRequiredLibsX86Family")

fun getProjectFromFolder(arch: String) : String {
    var folder: String = Paths.get(ACBrLibFolder, "Fontes", ACBrProjectName, "bin", "Android", "jniLibs", arch).toString()
    if ( isDemo){
        folder = Paths.get(ACBrLibFolder, "Fontes", ACBrProjectName, "bin", "Demo", "Android", "jniLibs", arch).toString()
    }
    println("Copiando Bibliotecas de: " + folder);
    return folder
}

tasks.register<Copy>("copyLibs_x86"){

    duplicatesStrategy = DuplicatesStrategy.EXCLUDE

    if (isRequiredLibsX86Family) {
        val ProjectFromFolder = getProjectFromFolder("x86")

        from(ProjectFromFolder) {
            include("**/*.so")
        }

        from(Paths.get(ACBrDependenciesFolder, "OpenSSL", "openssl-1.1.1w", "i686-linux-android", "Dynamic").toString()) {
            include("**/*.so")
        }

        if (isRequiredLibXML2) {
            from(Paths.get(ACBrDependenciesFolder, "LibXML2", "libxml2-2.9.10", "i686-linux-android", "Dynamic").toString()) {
                include("**/*.so")
            }
        }
    }

    into(jniLibsFolder_x86)

}

tasks.register<Copy>("copyLibs_x86_64"){

    duplicatesStrategy = DuplicatesStrategy.EXCLUDE

    if (isRequiredLibsX86Family) {
        val ProjectFromFolder = getProjectFromFolder("x86_64")

        from(ProjectFromFolder) {
            include("**/*.so")
        }

        from(Paths.get(ACBrDependenciesFolder, "OpenSSL", "openssl-1.1.1w", "x86_64-linux-android", "Dynamic").toString()) {
            include("**/*.so")
        }

        if (isRequiredLibXML2) {
            from(Paths.get(ACBrDependenciesFolder, "LibXML2", "libxml2-2.9.10", "x86_64-linux-android", "Dynamic").toString()) {
                include("**/*.so")
            }
        }
    }

    into(jniLibsFolder_x86_64)

}

tasks.register<Copy>("copyLibs_arm64") {
    val ProjectFromFolder = getProjectFromFolder("arm64-v8a")

    duplicatesStrategy = DuplicatesStrategy.EXCLUDE

    from(ProjectFromFolder) {
        include("**/*.so")
    }
    from(Paths.get(ACBrDependenciesFolder, "OpenSSL", "openssl-1.1.1w", "aarch64-linux-android", "Dynamic").toString()) {
        include("**/*.so")
    }

    if ( isRequiredLibXML2){
        from(Paths.get(ACBrDependenciesFolder, "LibXML2", "libxml2-2.9.10", "aarch64-linux-android", "Dynamic").toString()) {
            include("**/*.so")
        }
    }
    println("copiando para" +jniLibsFolder_arm64)
    into(jniLibsFolder_arm64)

    doFirst {
        val files = file(ProjectFromFolder).listFiles()
        if (files == null || files.isEmpty()) {
            throw GradleException("Sem ACBrLib em: " + ProjectFromFolder)
        }
    }


}

tasks.register<Copy>("copyLibs_armeabi") {
    val ProjectFromFolder = getProjectFromFolder("armeabi-v7a")

    duplicatesStrategy = DuplicatesStrategy.EXCLUDE

    from(ProjectFromFolder) {
        include("**/*.so")
    }
    from(Paths.get(ACBrDependenciesFolder, "OpenSSL", "openssl-1.1.1w", "arm-linux-androideabi", "Dynamic").toString()) {
        include("**/*.so")
    }

    if ( isRequiredLibXML2){
        from(Paths.get(ACBrDependenciesFolder, "LibXML2", "libxml2-2.9.10", "arm-linux-androideabi", "Dynamic").toString()) {
            include("**/*.so")
        }
    }

    into(jniLibsFolder_armeabi)

    doFirst {
        val files = file(ProjectFromFolder).listFiles()
        if (files == null || files.isEmpty()) {
            throw GradleException("Sem ACBrLib em: " + ProjectFromFolder)
        }
    }
}

tasks.register("checkACBrFolder") {
    doFirst {
        if (ACBrFolder == null || ACBrFolder.isEmpty()) {
            throw GradleException("Variável de ambiente ACBR_HOME não definida")
        }
    }
}
tasks.register<Copy>("copyLibs") {


    println("ACBR_HOME " + ACBrFolder)
    println("Copiando Bibliotecas para pasta: " + jniLibsFolder);



    dependsOn(
        tasks.getByName("checkACBrFolder"),
        tasks.getByName("copyLibs_arm64"),
        tasks.getByName("copyLibs_armeabi"),
        tasks.getByName("copyLibs_x86"),
        tasks.getByName("copyLibs_x86_64")

    )
}

tasks.register<Delete>("deleteJni") {
    doFirst {
        println(jniLibsFolder)
    }
    delete(jniLibsFolder)

}

tasks.getByName("preBuild").dependsOn("copyLibs")
tasks.getByName("clean").dependsOn("deleteJni")