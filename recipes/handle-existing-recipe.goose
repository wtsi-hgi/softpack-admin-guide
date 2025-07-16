version: "1.0.0"
title: "Handle Existing Recipe"
description: "Handle existing recipes and determine if version updates are needed"
instructions: |
  You are a Spack recipe management expert. Handle existing recipes and determine if version
  updates are needed. The package type will be determined from URL analysis to guide
  appropriate version management strategies.

parameters:
  - key: package_name
    input_type: string
    requirement: required
    description: "Name of the package"
  
  - key: recipe_name
    input_type: string
    requirement: required
    description: "The Spack recipe name with prefix"
  
  - key: recipe_exists
    input_type: string
    requirement: required
    description: "Whether the recipe exists"
  
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
  Handle existing recipe for {{ package_name }} ({{ recipe_name }}).
  
  Package URL: {{ package_url }}
  Recipe exists: {{ recipe_exists }}
  
  First, analyze the package URL to determine the package type, then manage the existing recipe:
  
  1. **Package Type Detection from URL**:
     - Analyze the URL to determine if it's Python, R, or other
     - Look for domain indicators: pypi.org (Python), cran.r-project.org (R), bioconductor.org (R)
     - For GitHub repositories, analyze repository language, README content, file structure
     - For other URLs, look for language-specific file patterns
  
  2. **Check Current Versions**:
     - Run: `spack versions {{ recipe_name }}`
     - List all currently available versions
     - Identify the latest version in the recipe
  
  3. **Check Latest Available Version**:
     - Based on detected package type, check the appropriate source:
       * Python packages: Check PyPI for latest version
       * R packages: Check CRAN/Bioconductor for latest version
       * Other packages: Check GitHub releases or other sources
     - Compare with current recipe versions
  
  4. **Determine Version Update Need**:
     - Check if a newer version is available
     - Assess if the newer version is needed
     - Consider stability and compatibility factors
  
  5. **Handle Version Updates** (if needed):
     - For Python packages: Use PyPI to get checksums
     - For R packages: Use CRAN/Bioconductor to get checksums
     - For other packages: Use appropriate source for checksums
     - Run: `spack checksum -b {{ recipe_name }}`
     - Provide guidance for adding new versions
  
  6. **Provide Status Report**:
     - Report detected package type
     - List current versions in recipe
     - Report latest available version
     - Indicate if version update is needed
     - Provide next steps based on findings
  
  If no version update is needed, confirm the recipe is ready for use.
  If version update is needed, provide specific guidance for the update process. 