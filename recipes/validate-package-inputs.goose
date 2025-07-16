version: "1.0.0"
title: "Validate Package Inputs"
description: "Validate and normalize package name, type, and URL inputs"
instructions: |
  You are a package validation expert. Validate the provided package inputs to ensure they meet
  the requirements for Spack package creation. Check package names, types, and URLs for validity.
  Normalize package names to follow Spack conventions. Use web tools to automatically detect
  package type from the provided URL.

parameters:
  - key: package_name
    input_type: string
    requirement: required
    description: "Name of the package to validate"
  
  - key: package_url
    input_type: string
    requirement: required
    description: "URL to the package repository or documentation (used to auto-detect package type)"
  
  - key: validation_level
    input_type: string
    requirement: optional
    default: "standard"
    description: "Level of validation to perform (basic, standard, comprehensive)"

extensions:
  - type: builtin
    name: developer
    timeout: 300
    bundled: true

prompt: |
  Validate the package inputs for {{ package_name }}.
  
  Package URL: {{ package_url }}
  Validation level: {{ validation_level }}
  
  First, use web tools to analyze the package URL and determine the package type:
  
  1. **URL Analysis and Package Type Detection**:
     - Visit the package URL to analyze its content
     - Check for package type indicators:
       * PyPI packages: Look for Python-specific content, setup.py, pyproject.toml
       * CRAN packages: Look for R-specific content, DESCRIPTION file, R code
       * Bioconductor packages: Check for Bioconductor-specific metadata
       * GitHub repositories: Analyze repository language, README content, file structure
       * Other sources: Look for language-specific files and documentation
  
  2. **Package Name Validation**:
     - Check if the package name is valid and follows naming conventions
     - Normalize the package name to lowercase and remove invalid characters
     - Ensure it doesn't contain reserved words or special characters
  
  3. **URL Validation**:
     - Check if the URL is accessible and returns a valid response
     - Verify the URL format is correct
     - Test basic connectivity to the URL
  
  4. **Comprehensive Checks** (if validation_level is comprehensive):
     - For Python packages: Check PyPI for package metadata
     - For R packages: Check CRAN for package information
     - For Bioconductor packages: Check Bioconductor repository
     - Verify package metadata and basic information
  
  5. **Package Type Determination**:
     - Based on URL analysis, determine the most appropriate package type
     - Consider the following indicators:
       * Python: .py files, setup.py, pyproject.toml, requirements.txt, Python documentation
       * R: .R files, DESCRIPTION, NAMESPACE, R documentation, CRAN/Bioconductor metadata
       * Other: C/C++ files, Makefile, CMakeLists.txt, or other language indicators
  
  Provide a detailed validation report including:
  - Determined package type with confidence level
  - Any issues found and recommendations for fixes
  - Normalized package name
  - URL accessibility status
  - Package metadata summary 