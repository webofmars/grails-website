node('docker') {

  // get arround a git scm anoying feature
  stage ('Bootstrap') {
    sh "echo GIT_BRANCH_LOCAL=\\\"$GIT_BRANCH\\\" | sed -e 's|origin/||g' | tee version.properties"
  }

  stage('Checkout') {
    load('version.properties')
    checkout([$class: 'GitSCM', branches: [[name: '**']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'LocalBranch', localBranch: "${GIT_BRANCH_LOCAL}"]], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/webofmars/grails-website.git']]])
  }

  stage('Build') {
    sh "./grailsw compile"
  }

  stage('Package with docker') {
    sh "cd ${WORKSPACE} && docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."
  }

  stage('Publishing with docker') {
    sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
  }

  /*** using the rancher plugin ***
    stage('Deploy') {
      rancher confirm: false, credentialId: '098cb525-c58f-480e-a184-1a881de49cff', endpoint: "${RANCHER_URL}", environmentId: "${RANCHER_ENV_ID}", environments: '', image: "${RANCHER_IMAGE}", ports: '', service: "${RANCHER_STACK}", timeout: 100
    }
  ***/
}