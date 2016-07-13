// jettyUrl = 'http://localhost:8081/'

// def servers

stage 'Dev'
node {
    // checkout scm
    // servers = load 'servers.groovy'
    
    // Prepare local Maven repo.
    // mvn '-o -Dmaven.test.failure.ignore clean install'

    // mvn '-o clean package'
    // dir('target') {stash name: 'war', includes: 'x.war'}
}

// input message: "Objects Under Test are published to QA?"
// try {
//     checkpoint('Before QA')
// } catch (NoSuchMethodError _) {
//     echo 'Checkpoint feature available in CloudBees Jenkins Enterprise.'
// }

stage 'QA'
node {
    checkout scm
    // mvn "-o -X -f selenium2-maven-test test"
    // mvn "-o -f sometests test -Durl=${jettyUrl}${id}/ -Dduration=${duration}"
    mvn "-o -X test"
}

// parallel(longerTests: {
//     runTests(servers, 30)
// }, quickerTests: {
//     runTests(servers, 20)
// })

// stage name: 'Staging', concurrency: 1
// node {
//     servers.deploy 'staging'
// }

input message: "Does QA look good?"
try {
    checkpoint('Before production')
} catch (NoSuchMethodError _) {
    echo 'Checkpoint feature available in CloudBees Jenkins Enterprise.'
}

stage 'Production'
node {

}

// stage name: 'Production', concurrency: 1
// node {
//     sh "wget -O - -S ${jettyUrl}staging/"
//     echo 'Production server looks to be alive'
//     servers.deploy 'production'
//     echo "Deployed to ${jettyUrl}production/"
// }

def mvn(args) {
    sh "${tool 'Maven 3.x'}/bin/mvn ${args}"
}

// def runTests(servers, duration) {
// def runTests(duration) {
//     node {
//         // checkout scm
//         // servers.runWithServer {id ->
//         //     mvn "-o -f sometests test -Durl=${jettyUrl}${id}/ -Dduration=${duration}"
//         // }

//     }
// }
