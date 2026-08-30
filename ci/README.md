# CI/CD Setup

The GitHub Actions workflow at .github/workflows/quality.yml runs on every
push and pull request. It checks whitespace, duplicated code, build status,
unit tests, and test coverage for the bundled calculator example.

The workflow is intentionally language-agnostic. It calls the same yeet
commands that are available locally; the project config decides whether those
commands run C++, Python, JavaScript, or another toolchain.

## Adding a project

Create projects/<project>.env and define commands for the checks that the CI
job should run. For example:

    YEET_PROJECT_ROOT="$HOME/projects/my-app"
    YEET_BUILD_APP="python -m compileall src tests"
    YEET_RUN_UT="pytest"
    YEET_CPD="npx --yes jscpd src tests"
    YEET_COVERAGE="pytest --cov=src --cov-report=term-missing --cov-fail-under=90"

Then replace the example project names in the workflow, or add a matrix entry
when several projects should be checked by the same pipeline.

## Coverage policy

The bundled calculator has YEET_COVERAGE_MIN=90 in projects/calculator.env.
Its coverage command exits with a failure when line coverage is below that
value, so the pull request check cannot pass with a lower result.

For other languages, put the threshold in the native coverage command. For
example, use --cov-fail-under=90 with pytest-cov or the equivalent option of
the coverage tool used by the project.

## Requiring the check before merge

The workflow reports a failing status when any check fails. To make GitHub
block pull request merges until the workflow passes, add the job
Build, tests and quality checks as a required status check in the repository
branch protection rules or ruleset for the default branch.
