version: "1.0.0"
title: "Spack Package Creation Workflow"
description: "Complete workflow for creating Spack packages from request to PR"
instructions: |
  You are a Spack package creation expert. Follow the step-by-step workflow to create Spack packages.
  Use the available sub-recipe tools to validate inputs, check recipe existence, create new recipes,
  modify recipes, build and test packages, and create pull requests.
  
  The workflow follows these steps:
  1. Validate package inputs (name, type, URL)
  2. Check if recipe already exists
  3. Handle existing recipes or create new ones
  4. Modify and improve recipes
  5. Build and test packages
  6. Create pull requests for successful packages

parameters:
  - key: package_name
    input_type: string
    requirement: required
    description: "Name of the package to create (e.g., numpy, ggplot2)"
  
  - key: package_url
    input_type: string
    requirement: required
    description: "URL to the package repository or documentation (used to auto-detect package type)"

sub_recipes:
  - name: "validate_inputs"
    path: "./recipes/validate-package-inputs.goose"
    values:
      validation_level: "comprehensive"
  
  - name: "check_recipe_existence"
    path: "./recipes/check-recipe-existence.goose"
  
  - name: "handle_existing_recipe"
    path: "./recipes/handle-existing-recipe.goose"
  
  - name: "create_new_recipe"
    path: "./recipes/create-new-recipe.goose"
  
  - name: "modify_recipe"
    path: "./recipes/modify-recipe.goose"
  
  - name: "build_and_test"
    path: "./recipes/build-and-test-package.goose"
  
  - name: "create_pull_request"
    path: "./recipes/create-pull-request.goose"
  
  - name: "handle_build_failure"
    path: "./recipes/handle-build-failure.goose"
  
  - name: "handle_creation_failure"
    path: "./recipes/handle-recipe-creation-failure.goose"

extensions:
  - type: builtin
    name: developer
    timeout: 300
    bundled: true

prompt: |
  Create a Spack package for {{ package_name }}.
  
  Package URL: {{ package_url }}
  
  First, analyze the package URL to determine the package type:
  - Check if it's a PyPI package (pypi.org)
  - Check if it's a CRAN package (cran.r-project.org)
  - Check if it's a GitHub repository with language indicators
  - Check if it's a Bioconductor package (bioconductor.org)
  - Default to "other" if type cannot be determined
  
  Follow this workflow:
  
  1. First, validate the package inputs using the validate_inputs tool
  2. Check if a recipe already exists using the check_recipe_existence tool
  3. If the recipe exists, use handle_existing_recipe to manage it
  4. If the recipe doesn't exist, use create_new_recipe to create it
  5. Modify the recipe using the modify_recipe tool
  6. Build and test the package using the build_and_test tool
  7. If successful, create a pull request using the create_pull_request tool
  
  If any step fails, use the appropriate error handling tool (handle_build_failure or handle_creation_failure).
  
  Provide clear status updates at each step and handle any errors gracefully. 