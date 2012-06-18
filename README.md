# MRStackExample

MRStackExample is a sample iPhone app that displays questions from StackOverflow using the StackExchange API. I built it demonstrate one "correct" architecture for designing mobile apps to interact with web backends.

## Core Principles

What does it mean for an architecture to be "correct"? Roughly speaking:

- There should be clean separations between models, views, and controllers.
- Code for a given behavior should be in one single, predictable place.
- Each object should expose a sensible interface to the other objects it interacts with.
- Objects should be loosely coupled, and each object should internally manage its own state. We should be able to swap out individual objects for testing, debugging, or further development.

Mapping this to our specific context of an iPhone app that interacts with a RESTful API, we get some useful constraints:

- The actual interactions with the API should be managed by a single object.
- This object should not be a singleton or otherwise a global variable.
- Individual model object classes should represent the API resources we are working with; these objects should internally contain knowledge of parsing and state.
- Our parser and API calls should be robust to changes in the server-side API (as much as possible).
- Data fetched from the API should be cached and readily available; we should be able to expire this data and refresh the cache as needed.
- Views and controllers should declare the data they are responsible for displaying and working with; the model layer and API interactions should not be coupled to any specific views or controllers.
- Parent controllers should configure and initalize their children to access the data source (whether it be the API/cloud data source, a local cache, or arbitrary data).

The recurring theme here is to use OOP design concepts so that we can avoid brittle code and unnecessary repetition. This code demonstrates **one** way to achieve these goals, but there exist many solutions, both variations on this theme as well as very different approaches. There is no definitive recipe; adapt the ideas here to your own situation.

## How does it work?

I will briefly describe the layers of the app here; for full details, check out the code and comments.

### Model Layer

Each resource we work with gets its own custom NSObject subclass. Currently, the app is incredibly simple and only shows a list of questions, so the only such object we have is ```SEQuestion```.

We're using NSKeyValueCoding protocol methods within each NSObject subclass to handle parsing of JSON dictionary representations of the object. The specific methods I used (see code) result in an interface that centralizes parsing code and special cases (e.g. type-casting) in one place, while being robust to API changes.

In addition to model objects to represent each resource, we want to encapsulate the notion of a "data source" for the app. Note that this does not necessarily require Internet access or a specific API! The app currently relies solely on a "cloud data source," but you could easily add other data sources, such as a "local data source" that would persist cached data to disk.

The cloud data source encapsulates knowledge of API interactions; it caches returned data from the API in memory, and it exposes a straightforward interface (using Obj-C properties) that the rest of the app can use to work with this data. Separately, each NSObject subclass encapsulates knowledge of how to parse data from a dictionary to create an instance of itself.

### Controller Layer

View controllers only need to know that there exists a data source with the data they need; in other words, they consume data, regardless of where it comes from. This is represented by the ```SEDataConsumer``` protocol, which the view controllers in our app will implement in order to work with the data source.

Because this app is so simple, we're using NSNotifications to have each view controller declare the data it wants to work with from the API. When the view controller appears, it registers for the notification, then asks the ```SECloudDataSource``` to fetch updated data from the API. When the data has arrived and been parsed, the ```SECloudDataSource``` will post the relevant notification, telling all registered listeners that new data is available. Each listener can update itself as needed; here, we simply need to call ```reloadData``` on the tableView.

We are using a design pattern known as **dependency injection** -- what this means is that the dependency (the data source) is injected by each parent object into its descendants as needed. This is much better than the naive alternative, which is to give each controller access to a global dataSource variable (or a singleton, which is the same thing as a global variable).

So, the dependency (the ```SECloudDataSource```) is created at the very top level, in the app delegate. We then inject this dependency into the root view controller of our app, the SEQuestionsViewController. If this view controller had child view controllers that needed to work with the data, it would itself be responsible for instantiating them and injecting the dependency -- it can do this, since it has a pointer to the data source.

In this way, the dependency is injected down the inheritance chain; at any point, however, an object can change it, or substitute it. For example, we could have a section of our app dedicated to testing, where we might pass in a different DataSource, with stubbed-out methods or preloaded data.

### View Layer

In this app, we don't have separate custom views, but an easy example in this direction (an exercise for the reader ;) would be to create a custom UIView subclass that represents ```SEQuestion``` -- specifically, a hypothetical ```SEQuestionTableViewCell```.

Views should function as "dumb" views, without knowledge of either the data source or any specific object. By way of a custom initializer or an exposed property, the dependency (a specific object) can be injected into the view subclass by a view controller; the view subclass then encapsulates knowledge of how to display that object.

## Closing Thoughts

Thanks to AFNetworking for their great and simple NSURLConnection wrapper. I've bundled the library here so you can just clone this project and run it.

Remember that this code demonstrates **one** way to build a clean, decoupled architecture; it is not **the** way, because **the** way does not exist. Adapt the approaches here to match the problem you're solving.

This whole repo is a work in progress. I wrote all the code currently here in a ~1.5 hour code sprint, to take a break from another project and to see if I could get a client-server app running in less than 2 hours. I may update this code with more functionality later, as time permits (let me know if you have specific feature requests).

Feedback, comments, and/or dissenting opinions on architecture are always welcome! Email me or open a pull request for discussion.