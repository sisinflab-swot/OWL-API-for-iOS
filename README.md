# OWL API for iOS

This project aims to provide a native iOS API to work with OWL ontologies.
While it is still a work in progress, the API can currently parse, deserialize and query
ontologies in OWL functional syntax containing ALEN DL constructs.

The model layer of the API is largely based on the [OWL API](http://owlcs.github.io/owlapi)
in order to simplify integration with existing software and provide familiar interfaces.
The parser and data model are built on top of [Cowl](http://swot.sisinflab.poliba.it/cowl),
which ensures that the library has satisfactory performance on iOS devices in terms of 
memory usage and turnaround time of parsing and querying operations.

## Using the framework

The framework can be built on any computer running **macOS** with **Xcode** installed. It supports **iOS 8.0** and later.

### Building the framework

- Install *CMake*, which is required in order to build Cowl.
  If you use *HomeBrew*: `brew install cmake`
- Clone this project: `git clone --recursive https://github.com/sisinflab-swot/OWL-API-for-iOS.git`
- Open *OWLAPI.xcodeproj*, select the *OWLAPI-Universal-iOS* target and run it,
  or archive it for a release build.

### Adding the framework to your iOS app

- Copy the framework anywhere into the directory of your project.
- Open your Xcode project and navigate to its build settings.
- In the *"General"* tab, add the compiled framework to the *Frameworks and Libraries* section.

### Usage examples

Here are some examples to get you started with *OWL API for iOS*.
To learn more about what you can do with it, check out the
[online documentation](https://sisinflab-swot.github.io/OWL-API-for-iOS/).

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
[ontology enumerateClassesInSignatureWithHandler:^(id<OWLClass> owlClass) {
    NSLog(@"%@", owlClass);
}];
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
ontology.enumerateClassesInSignature { owlClass in
    print(owlClass)
}
```

## References

If you want to refer to OWL API for iOS in a publication, please cite the following paper:
[[Ruta *et al.*, OWL API for iOS]](http://sisinflab.poliba.it/publications/2016/RSDB16/)

```
@InProceedings{RSDB16,
  author       = {Michele Ruta and Floriano Scioscia and Eugenio {Di Sciascio} and Ivano Bilenchi},
  title        = "OWL API for iOS: early implementation and results",
  booktitle    = "13th OWL: Experiences and Directions Workshop and 5th OWL reasoner evaluation workshop (OWLED - ORE 2016)",
  series       = "Lecture Notes in Computer Science",
  volume       = "10161",
  pages        = "141--152",
  month        = "nov",
  year         = "2016",
  editor       = "Mauro Dragoni, Mar\'{\i}a Poveda-Villal\'on, Ernesto Jimenez-Ruiz",
  publisher    = "Springer",
  organization = "W3C",
  note         = "DOI: 10.1007/978-3-319-54627-8",
  url          = "http://sisinflab.poliba.it/publications/2016/RSDB16"
}
```

## License

*OWL API for iOS* is distributed under the
[Eclipse Public License, Version 1.0](https://www.eclipse.org/legal/epl-v10.html).
