OWL API for iOS
===============

This project aims to provide a native iOS API to work with OWL ontologies. While it is still a work in progress, the API can currently parse, deserialize and query RDF/XML ontologies containing AL, AL+, ALE and ALN DL constructs.

The model layer of the API is largely based on [OWL API](http://owlcs.github.io/owlapi) in order to simplify integration with existing software and provide familiar interfaces. The parser component is built on top of the [Redland RDF Libraries](http://librdf.org), and it is specifically optimized to provide satisfactory performance on iOS devices in terms of both memory usage and turnaround time of parsing and querying operations.

### Compatibility

*OWL API for iOS* supports iOS 8.0 and later.

### License

*OWL API for iOS* is distributed under the [Eclipse Public License, Version 1.0](https://www.eclipse.org/legal/epl-v10.html).
