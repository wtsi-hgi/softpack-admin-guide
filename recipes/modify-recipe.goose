version: "1.0.0"
title: "Modify Recipe"
description: "Modify and improve Spack recipes with proper metadata, dependencies, and configuration"
instructions: |
  You are a Spack recipe modification expert. Modify and improve Spack recipes with proper
  metadata, dependencies, and configuration. The package type will be determined from URL
  analysis to guide appropriate modifications.

parameters:
  - key: package_name
    input_type: string
    requirement: required
    description: "Name of the package"
  
  - key: package_url
    input_type: string
    requirement: required
    description: "URL to the package repository (used to determine package type)"
  
  - key: recipe_name
    input_type: string
    requirement: required
    description: "The Spack recipe name with prefix"
  
  - key: creation_method
    input_type: string
    requirement: optional
    description: "Method used to create the recipe"

extensions:
  - type: builtin
    name: developer
    timeout: 300
    bundled: true

prompt: |
  Modify and improve the Spack recipe for {{ package_name }} ({{ recipe_name }}).
  
  Package URL: {{ package_url }}
  {% if creation_method %}
  Creation method: {{ creation_method }}
  {% endif %}
  
  First, analyze the package URL to determine the package type, then perform appropriate modifications:
  
  1. **Package Type Detection from URL**:
     - Analyze the URL to determine if it's Python, R, or other
     - Look for domain indicators: pypi.org (Python), cran.r-project.org (R), bioconductor.org (R)
     - For GitHub repositories, analyze repository language, README content, file structure
     - For other URLs, look for language-specific file patterns
  
  2. **Copy PyPackageCreator Output** (if applicable):
     - If creation_method is "pypackage_creator", copy generated packages to spack-repo
     - Run: `del_empty && mv ~/r-spack-recipe-builder/packages/py-* ~/spack-repo/packages`
  
  3. **Research Package Information**:
     - Visit the package URL to gather comprehensive information
     - For Python packages: Check PyPI for metadata, dependencies, description
     - For R packages: Check CRAN/Bioconductor for package information
     - For other packages: Analyze repository content and documentation
  
  4. **Update Recipe Metadata**:
     - Add proper description and homepage URL
     - Add git repository URL if it's a GitHub repo
     - Add license information
     - Update maintainer information if available
  
  5. **Add Dependencies** (based on detected package type):
     - For Python packages: Add Python dependencies, setuptools, wheel, etc.
     - For R packages: Add R dependencies, common R packages
     - For other packages: Add appropriate build and runtime dependencies
  
  6. **Update Package Class** (based on detected package type):
     - For Python packages: Change to PythonPackage class
     - For R packages: Change to RPackage class
     - For other packages: Keep default Package class or use appropriate base class
  
  7. **Add Version with Commit** (if applicable):
     - If creation_method is "commit_sha", add version with commit hash
     - Format: `version("YYYYMMDD", commit="commit_hash")`
  
  8. **Validate Recipe Syntax**:
     - Check Python syntax: `python3 -m py_compile packages/{{ recipe_name }}/package.py`
     - Report any syntax errors and provide fixes
  
  Provide a detailed modification report including:
  - Detected package type
  - Modifications applied
  - Any issues found and fixes made
  - Next steps for testing 