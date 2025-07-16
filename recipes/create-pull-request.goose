version: "1.0.0"
title: "Create Pull Request"
description: "Create pull requests for successfully built and validated packages"
instructions: |
  You are a Git and GitHub expert. Create pull requests for successfully built and validated
  Spack packages. Handle the entire Git workflow from branch creation to PR submission.

parameters:
  - key: package_name
    input_type: string
    requirement: required
    description: "Name of the package"
  
  - key: recipe_name
    input_type: string
    requirement: required
    description: "The Spack recipe name with prefix"
  
  - key: build_success
    input_type: string
    requirement: required
    description: "Whether the build was successful"
  
  - key: validation_success
    input_type: string
    requirement: required
    description: "Whether the validation was successful"

extensions:
  - type: builtin
    name: developer
    timeout: 300
    bundled: true

prompt: |
  Create a pull request for {{ package_name }} ({{ recipe_name }}).
  
  Build success: {{ build_success }}
  Validation success: {{ validation_success }}
  
  Follow this Git workflow:
  
  1. **Verify Prerequisites**:
     - Ensure both build and validation were successful
     - If either failed, do not proceed with PR creation
     - Confirm the recipe is ready for submission
  
  2. **Create Feature Branch**:
     - Create and switch to a new branch: `git checkout -b add-{{ package_name }}-recipe`
     - Use descriptive branch name following the pattern: `add-[package-name]-recipe`
  
  3. **Stage Changes**:
     - Add the new recipe files: `git add packages/{{ recipe_name }}/`
     - Include any additional files (patches, etc.)
     - Verify the changes are staged correctly
  
  4. **Commit Changes**:
     - Create a descriptive commit message: `git commit -m "Add {{ recipe_name }} recipe"`
     - Keep the commit message concise and descriptive
     - Include the package name and type in the message
  
  5. **Push to Remote**:
     - Push the feature branch: `git push origin add-{{ package_name }}-recipe`
     - Ensure the branch is available on the remote repository
  
  6. **Create GitHub Pull Request**:
     - Create a PR from the feature branch to main
     - Include appropriate title and description
     - Add relevant labels and assignees if needed
     - Provide the PR URL for reference
  
  7. **Provide Summary**:
     - Confirm PR creation was successful
     - Include the PR URL
     - List next steps (review, CI checks, merge)
  
  If any step fails, provide specific error messages and guidance for resolution.
  Only proceed with PR creation if both build and validation were successful. 