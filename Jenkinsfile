def image

def repo = ecs.withRepository("medicitv/rclone-storage")

def slack_channel = "#devbots"

pipeline {
    agent none

    stages {

        ////////////////////////////////// docker image build //////////////////////////////////
        stage('Image') {
            agent { label 'servicebuilder' }

            when {
                beforeAgent true
                anyOf {
                    changeRequest()
                    buildingTag() 
                    branch 'master'
                }
            }

            stages {

                stage('Image/Build') {
                    steps {
                        script {
                            echo 'Building...'
                            docker.withRegistry(repo.registry, repo.credential) {
                                image = docker.build(repo.name, ".")
                            }
                        }
                    }
                }

                stage('Image/Publish') {
                    steps {
                        script {
                            echo 'Publishing...'
                            docker.withRegistry(repo.registry, repo.credential) {
                                utils.getCommitTags().each{
                                    tag -> image.push(tag)
                                }
                            }
                            docker.withRegistry(repo.registry, repo.credential) {
                                image.push()
                            }                            
                        }
                    }
                }
            }
        }
    }
}
