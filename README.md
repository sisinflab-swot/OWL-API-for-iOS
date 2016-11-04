# OWL API for iOS

This project aims to provide a native iOS API to work with OWL ontologies. While it is still a work in progress, the API can currently parse, deserialize and query RDF/XML ontologies containing ALEN DL constructs (with the addition of role hierarchies).

The model layer of the API is largely based on [OWL API](http://owlcs.github.io/owlapi) in order to simplify integration with existing software and provide familiar interfaces. The parser component is built on top of the [Redland RDF Libraries](http://librdf.org), and it is specifically optimized to provide satisfactory performance on iOS devices in terms of both memory usage and turnaround time of parsing and querying operations.

## Using the framework

The framework can be built on any computer running **macOS** with **Xcode** installed. It supports **iOS 8.0** and later.

### Building the framework

- Install *pkg-config*, which is required in order to build raptor. If you use *HomeBrew*: `brew install pkg-config`
- Clone this project: `git clone https://github.com/sisinflab-swot/OWL-API-for-iOS.git`
- Open *OWLAPI.xcodeproj*, select the *OWLAPI-Universal-iOS* target and run it.

The first compilation may take several minutes, since the required dependencies will be downloaded and compiled beforehand. Once compilation completes, Finder will be automatically opened to the built framework path.

### Adding the framework to your iOS app

- Copy the framework anywhere into the directory of your project.
- Open your Xcode project and navigate to its build settings.
- In the *"General"* tab, add the compiled framework to the *"Embedded binaries"* section.

### Usage examples

Here are some examples to get you started with *OWL API for iOS*. To learn more about what you can do with it, check out the [online documentation](https://sisinflab-swot.github.io/OWL-API-for-iOS/).

**Objective-C:**

```objective-c
@import OWLAPI;

...

// Load the ontology
NSError *error;
NSURL *ontologyURL = [[NSBundle mainBundle] URLForResource:@"ontology" withExtension:@"owl"];

id<OWLOntologyManager> ontologyManager = [OWLManager createOWLOntologyManager];
id<OWLOntology> ontology = [ontologyManager loadOntologyFromDocumentAtURL:ontologyURL error:&error];

if (!ontology) {
    // Handle the error
    NSLog(@"%@", error);
    return;
}

// Query the ontology
for (id<OWLClass> owlClass in [ontology classesInSignature]) {
    NSLog(@"%@", owlClass);
}
```

**Swift:**

```swift
import OWLAPI

...

// Load the ontology
let ontologyURL = Bundle.main.url(forResource: "ontology", withExtension: "owl")!
let ontologyManager = OWLManager.createOWLOntologyManager()

var ontology: OWLOntology

do {
    ontology = try ontologyManager.loadOntologyFromDocument(at: ontologyURL)
} catch let error {
    // Handle the error
    print(error)
    return
}

// Query the ontology
for owlClass in ontology.classesInSignature() {
    print(owlClass)
}
```

## License

*OWL API for iOS* is distributed under the [Eclipse Public License, Version 1.0](https://www.eclipse.org/legal/epl-v10.html).
