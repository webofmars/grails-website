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
    docker.withRegistry("https://docker.io", "${DOCKER_CREDS_ID}") {
      def newImage = docker.build("${DOCKER_IMAGE}:${BUILD_NUMBER}")
      newImage.push()
      newImage.push('latest')
      newImage.push("${GIT_BRANCH_LOCAL}")
    }
  }

  // tests unitaires
  stage('Tests U') {
    docker.image("${DOCKER_IMAGE}:${BUILD_NUMBER}").inside {
      sh "curl -v http://localhost:8080/"
    }
  }

  // tests fxels

  // test de charge

  // deploy staging
  /*** using the rancher plugin ***
    stage('Deploy') {
      rancher confirm: false, credentialId: '098cb525-c58f-480e-a184-1a881de49cff', endpoint: "${RANCHER_URL}", environmentId: "${RANCHER_ENV_ID}", environments: '', image: "${RANCHER_IMAGE}", ports: '', service: "${RANCHER_STACK}", timeout: 100
    }
  ***/

  // deploy prod

}