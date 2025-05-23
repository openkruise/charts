# Contributing

OpenKruise Charts is a collection of **community maintained** charts. Therefore we rely on you to test your changes sufficiently.


# Pull Requests

All submissions, including submissions by project members, require review. We use GitHub pull requests for this purpose. Consult [GitHub Help](https://help.github.com/articles/about-pull-requests/) for more information on using pull requests. See the above stated requirements for PR on this project.

## Versioning

Each chart's version follows the [semver standard](https://semver.org/). New charts should start at version `1.0.0`, if it's considered stable. If it's not considered stable, it must be released as [prerelease](#prerelease).

Any breaking changes to a chart (backwards incompatible) require:

  * Bump of the current Major version of the chart
  * State possible manual changes for this chart version in the `Upgrading` section of the chart's `README.md.gotmpl` ([See Upgrade](#upgrades))

A pseudo version called `next` is used to prepare changes for the next major release, any fix and optimization of the chart can be made in the next version. Before creating the actual new major version, one should copy the content of `next` version and make changes accordingly. As an example, when preparing for the new major release of kruise 1.8.0, the operations is as follows:
```
  cd <repo-root>/versions/kruise/
  cp -r next 1.8.0
```

Before creating a new minor version, one should copy the latest version of corresponding major version. As an example. when preparing for the next minor release of kruise 1.7.x, and the latest version of 1.7.x is 1.7.3, then the operation is as follows:
```
  cd <repo-root>/versions/kruise/
  cp -r 1.7.3 1.7.4
```


### Immutability

Each release for each chart must be immutable. Any change to a chart (even just documentation) requires a version bump. Trying to release the same version twice will result in an error.

### Artifact Hub Annotations

Since we release our charts on Artifact Hub we encourage making use of the provided chart annotations for Artifact Hub.

  * [https://artifacthub.io/docs/topics/annotations/helm/](https://artifacthub.io/docs/topics/annotations/helm/)

#### Changelog

We want to deliver transparent chart releases for our chart consumers. Therefore we require a changelog per new chart release.

Changes on a chart must be documented in a chart specific changelog in the `Chart.yaml` [Annotation Section](https://helm.sh/docs/topics/charts/#the-chartyaml-file). For every new release the entire `artifacthub.io/changes` needs to be rewritten. Each change requires a new bullet point following the pattern `- "[{type}]: {description}"`. You can use the following template:

```
name: kruise
version: 0.10.0
...
annotations:
  artifacthub.io/changes: |
    - "[Added]: Something New was added"
    - "[Changed]: Changed Something within this chart"
    - "[Changed]: Changed Something else within this chart"
    - "[Deprecated]: Something deprecated"
    - "[Removed]: Something was removed"
    - "[Fixed]: Something was fixed"
    - "[Security]": Some Security Patch was included"
```

# Testing

## Testing Workflows Changes

Minimally:

```
helm install charts/kruise
```

Follow this instructions for running a hello world workflow.

## New Application Versions

When raising application versions ensure you make the following changes:

- `values.yaml`: Bump all instances of the container image version
- `Chart.yaml`: Ensure `appVersion` matches the above container image and bump `version`

Please ensure chart version changes adhere to semantic versioning standards:

- Patch: App version patch updates, backwards compatible optional chart features
- Minor: New chart functionality (sidecars), major application updates or minor non-backwards compatible changes
- Major: Large chart rewrites, major non-backwards compatible or destructive changes

## Testing Charts

As part of the Continuous Integration system we run Helm's [Chart Testing](https://github.com/helm/chart-testing) tool.

The checks for this tool are stricter than the standard Helm requirements, where fields normally considered optional like `maintainer` are required in the standard spec and must be valid GitHub usernames.

Linting configuration can be found in [ct-lint.yaml](./.github/configs/ct-lint.yaml)

The linting can be invoked manually with the following command:

```
./scripts/lint.sh
```

## Publishing Changes

Before actually publish new releases, one should link the chart directory to the corresponding version directory. As an example, if one is about to release kruise 1.7.4, the operation is as follows: 

```
cd <repo-root>/charts
ln -sf ../versions/kruise/1.7.4 kruise
```

Changes are automatically publish whenever a commit is merged to master. The CI job (see `./.github/workflows/publish.yml`).
