//Pipeline variables
def colorCode = '#00FF00'
def changes = ''
def channel = ''
def emoji = ':rocket:'
def error = ''
def branch=''
def LABEL=''
def AGENT_LABEL = null

node {
  stage('set agent'){
  //CDK-Projects/Staging/fluidra_generic_api get agent label from job path
    AGENT_LABEL = "${JOB_NAME.split("/")[1].toLowerCase()}"
 }
}
pipeline {
    environment {
    AWS_REGION="eu-west-1"
        //AWS_PROFILE="${params.ENV}"
     GITBRANCH = "${GIT_BRANCH.split("/").size() > 1 ? GIT_BRANCH.split("/")[1] : GIT_BRANCH}"
        AWS_DEPLOY_STAGE_ENVIRONMENT = "${GIT_BRANCH.split("/")[1] == 'test' ? 'test' : GIT_BRANCH.split("/")[1] == 'develop' ? 'dev' : GIT_BRANCH.split("/")[1] == 'staging' ? 'staging' : GIT_BRANCH.split("/")[1] == 'master' ? 'root' : 'unknown'}"
        scannerHome = tool 'SonarQubeScanner4.0'
    }

    parameters {
        string(name: 'NOTIFY', defaultValue: 'yes', description: 'flag for Slack notification')
    }
                agent {
                        label "${AGENT_LABEL}-Fluidra-CT"
                }
         stages {

        stage('Clone and Prepare dependencies') {

            steps {
                deleteDir()
                sh '''(printenv)'''
                withFolderProperties{
                    script{
                git(
                    url: "git@github.com:RiiotLabs/platform-manual-services.git",
                    credentialsId: "ssh-key-slave_for_sub_modules",
                    branch: "${GIT_BRANCH.split("/").size() > 1 ? GIT_BRANCH.split("/")[1] : GIT_BRANCH}"
                 )
                     script {
                        try {

                                      withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key-slave_for_sub_modules', keyFileVariable: 'SSH_KEY')]) {

                                        sh '''
                                export GIT_SSH_COMMAND="ssh -i $SSH_KEY"
                                cd $WORKSPACE ; yes | git submodule update --init --recursive
                                cd $WORKSPACE && /bin/sh install.sh
                                '''
                         }

                            }
                         catch (Exception e) {
                            echo 'Exception occurred: ' + e.toString()
                            }
                        } 
                    }
                }
                slackNotify(
                    '#FFFF00',
                    "Build ${BUILD_DISPLAY_NAME} for platform-manual-services is STARTING. ${emoji}\n ${RUN_DISPLAY_URL}",
                    channel
                )
            }
        }
        
        stage('Fleet Indexing Script'){
          steps {
            script {
              sh "export AWS_REGION=eu-west-1 && export AWS_PROFILE=dev && sudo sh scripts/iot-fleet-indexing-config.sh"
            }
          }
        }

        stage('SonarQube analysis') {
            steps {
              script {
                  withSonarQubeEnv('sonar') {
                    sh "${scannerHome}/bin/sonar-scanner \
                    -Dsonar.projectKey=platform-manual-services-${AWS_DEPLOY_STAGE_ENVIRONMENT} \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=http://sonarqube.tools.emea-iot.aws.fluidra.com:9000 \
                    -Dsonar.login=7f96e77fa7f3b53a6206ccf3b68a2397b48fd97f \
                    -Dsonar.working.directory=WORKSPACE/sonar"
                  }
              }
		    slackNotify(
                    '#FFFF00',
                    "SonarQube Analysis for ${BUILD_DISPLAY_NAME} for platform-manual-services has been performed.${emoji}",
                    channel
                    )
            }
        }
        
        stage('Deploy') {

            steps {
              script{
                                      withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key-slave_for_sub_modules', keyFileVariable: 'SSH_KEY')]) {

                sh '''
                export GIT_SSH_COMMAND="ssh -i $SSH_KEY"
               cd ${WORKSPACE} ; ls -l ;  sls plugin install -n serverless-prune-plugin --stage ${AWS_DEPLOY_STAGE_ENVIRONMENT}
	       sls prune --stage ${AWS_DEPLOY_STAGE_ENVIRONMENT} -n 50; sls -v
	       sls deploy --stage ${AWS_DEPLOY_STAGE_ENVIRONMENT} --force
                '''
                }
               }
           }
        }
             
    }
      post {
          always {
              script{
                  changes = getChangeLogSets()
                  if("$changes") {
                    echo "Changes: \n${changes}"
                  } else {
                    changes = 'No changes detected'
                    echo "Changes: \n${changes}"
                  }
              }
              //cleanWs()

          }
          success {
              script {
                  emoji = ':sunny:'
                  colorCode = '#00FF00'
              }
              slackNotify(
                  colorCode,
                  "Deploy ${BUILD_DISPLAY_NAME} for platform-manual-services \nfrom branch ${AGENT_LABEL}\nresult: ${currentBuild.result}. ${emoji}\nBuild URL: ${RUN_DISPLAY_URL}\nChanges: \n${changes}",
                  channel
              )
          }
          failure {
              script {
                  emoji = ':thunder_cloud_and_rain:'
                  colorCode = '#FF0000'
              }
              slackNotify(
                  colorCode,
                  "Deploy ${BUILD_DISPLAY_NAME} for platform-manual-services \nfrom branch ${AGENT_LABEL}\nresult: ${currentBuild.result}. ${emoji}\nBuild URL: ${RUN_DISPLAY_URL}\nError: \n${error}\nChanges: \n${changes}",
                  channel
              )
          }
      }
}
//method to send slack message to specific channel
def slackNotify(color, message, channel) {
    if (params.NOTIFY == 'yes') {
        slackSend(
            channel: channel,
          color: color,
          tokenCredentialId: 'slack-token-EMEA-testing',
          baseUrl: 'https://fluidraemeaiot.slack.com/services/hooks/jenkins-ci/',
          teamDomain: 'fluidraemeaiot',
          message: message
        )
    }
}
//method to compile change logs

@NonCPS
def getChangeLogSets() {
  def changeLogSets = currentBuild.rawBuild.changeSets
  def changes=''
  def commits=[]
  for (int i = 0; i < changeLogSets.size(); i++) {
     def entries = changeLogSets[i].items
     for (int j = 0; j < entries.length; j++) {
          def entry = entries[j]
          if (commits.contains(entry.commitId.substring(0,6))) {
            echo "Duplicate changes."
            } else {
            changes+="${entry.commitId.substring(0,6)} by ${entry.author} on ${new Date(entry.timestamp)}: \n${entry.msg}\n"
          }
          commits+=entry.commitId.substring(0,6)
      }
  }
  return changes
}
