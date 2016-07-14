stage 'Dev'
node {
    // checkout scm
    
    // Prepare local Maven repo.
    // mvn '-o clean package'
    // dir('target') {stash name: 'war', includes: 'x.war'}
}

input message: "Application published to Integration?"
try {
    checkpoint('Before Integration')
} catch (NoSuchMethodError _) {
    echo 'Checkpoint feature'
}


stage 'Integration Test'
node {

}

input message: "Does Integration test result look good?"
try {
    checkpoint('Before Functional')
} catch (NoSuchMethodError _) {
    echo 'Checkpoint feature'
}


stage 'Functional Test'
node {
    checkout scm
    mvn "-o -X test"
}

input message: "Does functional test result look good?"
try {
    checkpoint('Before load test')
} catch (NoSuchMethodError _) {
    echo 'Checkpoint feature'
}


stage 'Load Test'
node {

}

input message: "Does load test result look good?"
try {
    checkpoint('Before production')
} catch (NoSuchMethodError _) {
    echo 'Checkpoint feature'
}


stage 'Production'
node {

}

def mvn(args) {
    sh "${tool 'Maven 3.x'}/bin/mvn ${args}"
}