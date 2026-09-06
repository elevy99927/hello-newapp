def appname = "hello-newapp"
def repo = "elevy99927"  // Replace with your DockerHub username
def appimage = "${repo}/${appname}"
def apptag = "${env.BUILD_NUMBER}"

podTemplate(containers: [
      containerTemplate(name: 'jnlp', image: 'jenkins/inbound-agent', ttyEnabled: true),
    containerTemplate(
        name: 'docker',
        image: 'docker:26-dind',
        privileged: true,
        args: '--storage-driver=vfs --host=tcp://0.0.0.0:2375'
    )
  ],
   volumes: [
    emptyDirVolume(mountPath: '/var/run', memory: false)
  ])
  {
    node(POD_LABEL) {
        stage('chackout') {
            container('jnlp') {
            sh '/usr/bin/git config --global http.sslVerify false'
	    checkout scm
          }
        } // end chackout

        stage('build') {
            container('docker') {
              echo "Building docker image..."
              sh "docker build . -t $appimage"
            }
        } //end build

        // Requires the "Docker Pipeline" plugin (docker-workflow) for docker.withRegistry/docker.image.
        // Install: Manage Jenkins > Plugins > Available plugins > "Docker Pipeline".
        // Configure credentials: Manage Jenkins > Credentials > (global) > Add Credentials
        //   Kind: "Username with password", ID: dockerhub-creds, Username: Docker Hub username,
        //   Password: a Docker Hub Access Token (Account Settings > Security > Access Tokens), not your account password.
        stage('push') {
            container('docker') {
              script {
                docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-creds') {
                  docker.image("$appimage").push()
                }
              }
            }
        } //end push
    }
}
