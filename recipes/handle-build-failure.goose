version: "1.0.0"
title: "Handle Build Failure"
description: "Handle build failures with diagnostic information and recovery steps"
instructions: |
  You are a Spack build troubleshooting expert. Handle build failures with comprehensive
  diagnostic information and recovery steps. The package type will be determined from URL
  analysis to provide targeted troubleshooting guidance.

parameters:
  - key: package_name
    input_type: string
    requirement: required
    description: "Name of the package that failed to build"
  
  - key: recipe_name
    input_type: string
    requirement: required
    description: "The Spack recipe name with prefix"
  
  - key: error_step
    input_type: string
    requirement: required
    description: "The step where the error occurred"
  
  - key: error_message
    input_type: string
    requirement: required
    description: "The error message from the failed step"
  
  - key: package_url
    input_type: string
    requirement: required
    description: "URL to the package repository (used to determine package type)"

extensions:
  - type: builtin
    name: developer
    timeout: 300
    bundled: true

prompt: |
  Handle build failure for {{ package_name }} ({{ recipe_name }}).
  
  Package URL: {{ package_url }}
  Error Step: {{ error_step }}
  Error Message: {{ error_message }}
  
  First, analyze the package URL to determine the package type, then provide targeted troubleshooting:
  
  1. **Package Type Detection from URL**:
     - Analyze the URL to determine if it's Python, R, or other
     - Look for domain indicators: pypi.org (Python), cran.r-project.org (R), bioconductor.org (R)
     - For GitHub repositories, analyze repository language, README content, file structure
     - For other URLs, look for language-specific file patterns
  
  2. **Analyze Build Failure**:
     - Review the error message and identify the root cause
     - Check build logs for detailed error information
     - Identify the specific failure point in the build process
  
  3. **Provide Type-Specific Troubleshooting**:
     - For Python packages: Check Python dependencies, setuptools, wheel issues
     - For R packages: Check R dependencies, CRAN/Bioconductor compatibility
     - For other packages: Check build system, compiler, and platform issues
  
  4. **Common Issues and Solutions**:
     - Missing dependencies: Add to depends_on() in recipe
     - Version constraints: Check version compatibility
     - Build flags: Verify build system configuration
     - Patches: Check if patches are needed
     - Platform issues: Check compiler and platform compatibility
  
  5. **Recovery Steps**:
     - Clean previous build attempts: `spack clean --all`
     - Check recipe syntax: `python3 -m py_compile packages/{{ recipe_name }}/package.py`
     - Validate recipe: `spack audit packages/{{ recipe_name }}/package.py`
     - Try verbose build: `spack install --verbose {{ recipe_name }}`
  
  6. **Generate Debug Information**:
     - Recipe file location and size
     - Build environment details
     - Compiler configuration
     - Platform information
  
  7. **Create Issue Template**:
     - Generate a GitHub issue template with all relevant information
     - Include error details, environment info, and reproduction steps
  
  Provide a comprehensive failure analysis including:
  - Detected package type
  - Root cause analysis
  - Type-specific troubleshooting steps
  - Recovery recommendations
  - Debug information
  - Issue template for reporting 