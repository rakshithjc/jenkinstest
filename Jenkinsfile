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
  ansiColor('xterm') {
    node('worker') {
        def pipeline;
        def testRunner;
        def image;
        def imageName;
        def currentStage = '';
        def testImageName;

        try {
            currentStage = 'Prepare Pipeline';
            stage(currentStage) {
                entering(currentStage);

                pipeline = new cicd.Pipeline();
                testRunner = pipeline.getTestRunnerInstance(['language': 'node']);
                pipeline.cleanupAndCheckout();
            }

            currentStage = 'Build Docker Image';
            stage(currentStage) {
                entering(currentStage);
                def version = VERSION_MAJOR + '.' + VERSION_MINOR + '.' + VERSION_PATCH
                def imageNameBase = pipeline.projectInfo().repoName;
                imageECS = pipeline.buildDockerImage([
                        appName   : imageNameBase + "_ecs",
                        appVersion: version
                ])
            }
            String lastCommitAuthor = getLastCommitAuthor();
            currentStage = 'npm run integration';
            stage(currentStage) {
                entering(currentStage);
                cleanDockerContainer();
                try {
                    sh "docker-compose -f docker-compose.yml  up --build"
                }
                finally {
                    cleanDockerContainer();
                }
            }
        }
        catch ( Throwable error) {
            println( error );
            String lastCommitAuthor = getLastCommitAuthor();
            if ( lastCommitAuthor == 'sali' ) {
//            || lastCommitAuthor == 'blah') {  add your name in to be notified
                slackSend(
                        channel:  '@' + lastCommitAuthor,
                        color: RED_COLOR,
                        message: "Build FAILED - ${env.BUILD_URL}"
                );
            } else {
                println('lastCommitAuthor=' +lastCommitAuthor);
            }
            println( 'In Catch: Current build status is: ' + currentBuild.currentResult);

            // rethrow the error otherwise the build status is not correct
            throw error;
        }
    }
}