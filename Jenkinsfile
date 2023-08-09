try {
  node {
        def app
        
        stage('Clone Repository') 
        {
            final scmVars = checkout(scm)
            env.BRANCH_NAME = scmVars.GIT_BRANCH
            env.SHORT_COMMIT = "${scmVars.GIT_COMMIT[0..7]}"
            env.GIT_REPO_NAME = scmVars.GIT_URL.replaceFirst(/^.*\/([^\/]+?).git$/, '$1')
        }
        
 
        stage('Build Docker Image') {
            app = docker.build("beaver-squad/${env.GIT_REPO_NAME}")
        }
        if (env.BRANCH_NAME == 'develop' || env.BRANCH_NAME == 'main') {
            stage('Veracode Docker Security Scan') {
                try {
                    // 3rd party scan docker container
                    withEnv(["https_proxy=http://proxy3:8080"]){
                        withCredentials([string(credentialsId: 'SRCCLR_API_TOKEN', variable: 'SRCCLR_API_TOKEN')]) {
                            sh "curl -sSL https://download.sourceclear.com/ci.sh | sh -s scan --image beaver-squad/${env.GIT_REPO_NAME}"
                        }
                    }
                } catch(Error|Exception e) {
                    echo "failed but we continue"
                } 
            } 
        }
        
        /* Finally, we'll push the image:
        * We tag the image with the incremental build number from Jenkins
        * Pushing multiple tags is cheap, as all the layers are reused.*/
        if  (env.BRANCH_NAME == 'uat') {
        stage('Push Image to openshift uat Registry') {
                retry(3) {
                    docker.withRegistry('https://ocr1.devocp.safaricom.net/', 'beaver-squad-Openshift-UAT') {
                        app.push("uat-${env.SHORT_COMMIT}")
                    }
                }
            }
        } else if (env.BRANCH_NAME == 'prod') {
            stage('Push Image to openshift prod Registry') {
                retry(3) {
                    env.VERSION = version()
                    docker.withRegistry('https://ocr2.devocp.safaricom.net/', 'beaver-squad-Openshift-PROD') {
                        app.push("v${env.Version}_${env.SHORT_COMMIT}")
                        app.push("latest")
                    }
                }
            }
        }
    }   
} catch(Error|Exception e) {
  //Finish failing the build after telling someone about it
  throw e
} finally {
    // Post build steps here
    /* Success or failure, always run post build steps */
    // send email
    // publish test results etc etc
}
def version()
{
    
    return 1.0
}


// @Library('global_shared_library') _ runPipeline(agent: 'nodejs-docker', environment: 'aws', technology: 'nodejs', account_name: 'DE', ENV_UAT: 'SIMPORTALSERVER_UAT', include_env:'true')