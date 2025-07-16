version: "1.0.0"
title: "Build and Test Package"
description: "Build and test Spack packages with validation"
instructions: |
  You are a Spack build and testing expert. Build packages using Spack and validate their
  functionality using appropriate testing methods. The package type will be determined
  from URL analysis. Handle build failures and provide guidance for troubleshooting.

parameters:
  - key: package_name
    input_type: string
    requirement: required
    description: "Name of the package"
  
  - key: recipe_name
    input_type: string
    requirement: required
    description: "The Spack recipe name with prefix"
  
  - key: package_url
    input_type: string
    requirement: required
    description: "URL to the package repository (used to determine package type for validation)"

extensions:
  - type: builtin
    name: developer
    timeout: 300
    bundled: true

prompt: |
  Build and test the Spack package {{ recipe_name }} ({{ package_name }}).
  
  Package URL: {{ package_url }}
  
  First, analyze the package URL to determine the package type, then follow this build and test process:
  
  1. **Package Type Detection from URL**:
     - Analyze the URL to determine if it's Python, R, or other
     - Look for domain indicators: pypi.org (Python), cran.r-project.org (R), bioconductor.org (R)
     - For GitHub repositories, analyze repository language, README content, file structure
     - For other URLs, look for language-specific file patterns
  
  2. **Build the Package**:
     - Run: `spack install {{ recipe_name }}`
     - Monitor the build process for any errors
     - Check build logs if the build fails
     - Report build success or failure
  
  3. **Handle Build Failures**:
     - If build fails, analyze the error messages
     - Common issues: missing dependencies, version constraints, build flags, patches
     - Provide specific guidance for fixing the issues
     - Suggest next steps for recipe modification
  
  4. **Validate the Package** (if build succeeds):
     - Based on detected package type, use appropriate validation:
       * Python packages: `python -c "import {{ package_name }}"`
       * R packages: `Rscript -e "library({{ package_name }})"`
       * Other packages: check package documentation for validation commands
     - Use Singularity for validation: `singularity exec --bind /mnt/data /home/ubuntu/spack.sif bash -c "source <(/opt/spack/bin/spack load --sh {{ recipe_name }}); [validation_command]"`
  
  5. **Handle Validation Failures**:
     - If validation fails, uninstall the package: `spack uninstall -y --all --dependents {{ recipe_name }}`
     - Check import paths and runtime dependencies
     - Provide alternative validation commands if needed
     - Suggest fixes for the recipe
  
  6. **Provide Status Report**:
     - Report detected package type
     - Report build success/failure
     - Report validation success/failure
     - Include any error messages and logs
     - Provide next steps based on results
  
  If both build and validation succeed, confirm the package is ready for PR creation.
  If either fails, provide detailed troubleshooting guidance. 