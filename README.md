<div id="top"></div>

<!-- PROJECT SHIELDS -->
[![CI][ci-shield]][ci-url]
[![Issues][issues-shield]][issues-url]
[![License][license-shield]][license-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]

<!-- HEADER -->
<br>
<div align="center">
  <h1 align="center">Adaptable Costs Evaluator (ACE)</h1>

  <p align="center">
    This repository contains the back-end of the ACE application. It is implemented as a web service with the REST API.
    <br>
    <a href="https://patrotom.github.io/adaptable-costs-evaluator/"><strong>Explore the REST API specification »</strong></a>
</div>

<!-- TABLE OF CONTENTS -->
<details open>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#development">Development</a></li>
    <li><a href="#wiki">Wiki</a></li>
    <li>
      <a href="#contributing">Contributing</a>
      <ul>
        <li><a href="#versioning">Versioning</a></li>
      </ul>
    </li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

The project is based on the [DSW Storage Costs Evaluator](https://storage-costs-evaluator.ds-wizard.org/) project. This project enables the users to dynamically compute storage costs based on the given input parameters. However, the computations are hard-coded in the back-end, and it is difficult to implement new changes. The intention behind the ACE was to create a REST API that would enable the clients to create, run, and store the computations in an adaptable and scalable manner. Alongside these features, ACE also supports a user system enabling authentication and authorization. It also brings an organization system that enables the application to implement database multi-tenancy.

### Built With

* [Elixir](https://elixir-lang.org/)
* [Phoenix Framework](https://www.phoenixframework.org/)
* [PostgreSQL](https://www.postgresql.org/)

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

To install and run the application, you need to install a few prerequisites and follow a couple of steps.

### Prerequisites

Install the following programs:

* [Docker](https://www.docker.com/)
* [Docker Compose](https://docs.docker.com/compose/)

### Installation

The installation of the application is straightforward since it is dockerized. These are the steps to build and run the application:

1. Clone the repo and go to the project directory.

   ```sh
   git clone https://github.com/patrotom/adaptable-costs-evaluator
   cd adaptable-costs-evaluator
   ```

2. Copy [.env.example](docs/envs/.env.example) to the root of your application. The example values of the environment variable should work locally without changes.

    ``` sh
    cp docs/envs/.env.example .env
    ```

3. Build the application.

    ``` sh
    docker-compose build
    ```

4. Run the application. There is a script that will automatically create and seed the database when you first run the application.

    ``` sh
    docker-compose up
    ```

5. All done! The application should run under [localhost:4000](http://localhost:4000/).

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->
## Usage

You can use your favorite HTTP client like [cURL](https://curl.se/) to call the API. Refer to the [REST API specification](https://patrotom.github.io/adaptable-costs-evaluator/).

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->
## Development

There are a few commands you might find handy while developing the app:

* `docker exec -ti adaptable_costs_evaluator_app_1 bash` - enter the application container with bash
* `mix test test` - run all tests in the [test](test) directory
* `mix openapi.spec.json --spec AdaptableCostsEvaluatorWeb.ApiSpec docs/openapi/openapi.json` - compile [OpenAPI](https://www.openapis.org/) from the code

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- Wiki -->
## Wiki

The [project's Wiki](https://github.com/patrotom/adaptable-costs-evaluator/wiki) contains additional information for the developers who wish to contribute to the code or integrate the application with the foreign systems.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTRIBUTING -->
## Contributing

Contributions are what makes the Open Source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a Pull Request. You can also simply open an Issue with the tag "enhancement".

Don't forget to give the project a star! Thanks again!

1. Fork the Project.
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`).
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the Branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

### Versioning

* The versioning scheme we use is [SemVer](https://semver.org/). If you plan to release a new version, increase the version in the [VERSION](VERSION) file.
* Create a new [GitHub Release](https://github.com/patrotom/adaptable-costs-evaluator/releases/new) and add a proper changelog to the description of the release.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- LICENSE -->
## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

Tomáš Patro - <tomas.patro@gmail.com>

Project Link: <https://github.com/patrotom/adaptable-costs-evaluator>

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

This project was created as part of the master thesis of Tomáš Patro at the [CTU, Faculty of Information Technology](https://fit.cvut.cz/) under the supervision of [Ing. Marek Suchánek](https://suchanek.cloud/).

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->

[ci-shield]: https://img.shields.io/github/workflow/status/patrotom/adaptable-costs-evaluator/Tests%20&%20Static%20Code%20Analysis?label=Tests%20%26%20Static%20Code%20Analysis&style=for-the-badge
[ci-url]: https://github.com/patrotom/adaptable-costs-evaluator/actions/workflows/ci.yml
[issues-shield]: https://img.shields.io/github/issues/patrotom/adaptable-costs-evaluator.svg?style=for-the-badge
[issues-url]: https://github.com/patrotom/adaptable-costs-evaluator/issues
[license-shield]: https://img.shields.io/github/license/patrotom/adaptable-costs-evaluator.svg?style=for-the-badge
[license-url]: https://github.com/patrotom/adaptable-costs-evaluator/blob/master/LICENSE
[forks-shield]: https://img.shields.io/github/forks/patrotom/adaptable-costs-evaluator.svg?style=for-the-badge
[forks-url]: https://github.com/patrotom/adaptable-costs-evaluator/network/members
[stars-shield]: https://img.shields.io/github/stars/patrotom/adaptable-costs-evaluator.svg?style=for-the-badge
[stars-url]: https://github.com/patrotom/adaptable-costs-evaluator/stargazers
