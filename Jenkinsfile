#!/usr/bin/env groovy
String getLastCommitAuthor() {
    String lastCommitAuthor =
        sh(script: "git log -1 --pretty=format:'%ae' | awk -F '@' '{print \$1};'", returnStdout: true).trim();

    return lastCommitAuthor;
}

def entering(stageName) {
    def equals = " ===============================================================================";
    def endIndex = equals.length() - stageName.length() - 1;
    if(endIndex < 0) {
        endIndex = 0;
    }
    println(BOLD_RED + stageName + equals.substring(0, endIndex) + ANSI_OFF);
}
void cleanDockerContainer() {
    // cleanup any leftover container
    try {
        sh "docker-compose down"
    } catch ( Exception ex ) {
        // this may throw an exception if a matching container was not running in the first place,
        // but that's okay, just catch and log.
        println( "Caught exception while cleaning out container (may be benign): " + ex );
        // Jenkins won't allow us to use ex.printStackTrace();
        }
    finally {
        trace( "List of container after clean up:");
        sh 'docker container ls -a'
    }
}
pipeline{
    agent any
    stages{
          stage('Docker-compose set') {
            withEnv(["PATH=$PATH:~/.local/bin"]){
                    sh "bash test.sh"
                }
        } 
        stage("Cleanup"){
            steps{
                cleanDockerContainer()
            }
        }
        stage("Docker-compose"){
            steps{
                sh "docker-compose up --build"
            }
        }

    }
}