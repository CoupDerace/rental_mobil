allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    val configureNamespace = {
        val android = extensions.findByName("android")
        if (android != null) {
            try {
                val manifestFile = file("${projectDir}/src/main/AndroidManifest.xml")
                var manifestPackage: String? = null
                if (manifestFile.exists()) {
                    var manifestContent = manifestFile.readText(Charsets.UTF_8)
                    val matchResult = Regex("package=\"([^\"]+)\"").find(manifestContent)
                    if (matchResult != null) {
                        manifestPackage = matchResult.groupValues[1]
                    }
                    if (manifestContent.contains("package=")) {
                        println("Removing package attribute from ${name} Manifest at configuration time")
                        manifestContent = manifestContent.replace(Regex("package=\"[^\"]*\""), "")
                        manifestFile.setWritable(true)
                        manifestFile.writeText(manifestContent, Charsets.UTF_8)
                    }
                }

                val namespaceMethod = android.javaClass.getMethod("getNamespace")
                val currentNamespace = namespaceMethod.invoke(android) as? String
                
                val targetNamespace = if (!currentNamespace.isNullOrEmpty()) {
                    currentNamespace
                } else if (!manifestPackage.isNullOrEmpty()) {
                    manifestPackage
                } else {
                    "com.example.${name.lowercase().replace(Regex("[^a-zA-Z0-9]"), "")}"
                }

                if (currentNamespace.isNullOrEmpty()) {
                    val setNamespaceMethod = android.javaClass.getMethod("setNamespace", String::class.java)
                    setNamespaceMethod.invoke(android, targetNamespace)
                }
            } catch (e: Exception) {
                // Ignore if getNamespace/setNamespace does not exist
            }
        }
    }

    if (state.executed) {
        configureNamespace()
    } else {
        afterEvaluate {
            configureNamespace()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

