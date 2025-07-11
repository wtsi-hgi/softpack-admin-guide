# Spack Package Creation Instructions

This document provides step-by-step instructions for creating and maintaining Spack packages.

## Prerequisites
- Access to the spack-repo workspace
- Have access to a VM built using [softpack-vm-setup](https://github.com/wtsi-hgi/softpack-vm-setup)

## Step-by-Step Process

### 1. Check for Existing Recipe
First, verify if a recipe already exists in the `packages/` directory:
- For Python packages: look for `py-{package_name}`
- For R packages: look for `r-{package_name}`
- For other packages: look for `{package_name}`

**Action**: Browse the `packages/` directory or use search tools to locate existing recipes.

### 2. Handle Version-Only Updates
If the recipe exists but you need a specific version:

```bash
# Get available versions
spack versions {package_name}

# Get SHA256 checksum for new version
spack checksum -b {package_name}
```

**Action**: Modify the existing recipe to add the new version with its corresponding SHA256 checksum.

### 3. Process URL Information
If the package request includes a URL (e.g., GitHub repository, documentation site):
- Visit and thoroughly review the URL content
- Take notes on important information such as:
  - Build requirements and dependencies
  - Installation instructions
  - Available versions and releases
  - Licence information
  - Import/usage examples
- This information will help guide your recipe creation decisions

### 4. Create Python Package Recipe

#### 4a. Try PyPI First
For Python packages, attempt to use the internal PyPackageCreator tool:

```bash
cd ~/r-spack-recipe-builder
./PyPackageCreator.py -f {package_name}
```

If successful, copy the generated recipe:
```bash
del_empty
mv ~/r-spack-recipe-builder/packages/py-* ~/spack-repo/packages
```

#### 4b. Check Official Spack Repository
If PyPI fails or for non-Python packages:

```bash
create {py-/r-}{package_name}
```

**What the `create` function does**:
The `create` command is a custom function defined in `.zshrc` that automates the process of checking for and copying recipes from the official Spack repository. It performs the following steps:

1. **Creates a temporary recipe**: Runs `spack create --skip-editor {package_name}` to generate a basic recipe
2. **Updates official repository**: Navigates to `~/work/spack-packages` and runs `git pull` to get the latest official Spack recipes
3. **Copies existing recipe**: If the package exists in the official repository, copies `package.py` and any `.patch` files from `~/work/spack-packages/repos/spack_repo/builtin/packages/` to your local `~/spack-repo/packages/` directory
4. **Cleans up the recipe**: Automatically performs several cleanup operations:
   - Comments out generic build dependencies (`c`, `cxx`, `fortran`)
   - Removes `checked_by` parameters from licence declarations
   - Removes imports from `spack_repo.builtin`

**Note**: Use appropriate prefix (`py-` for Python, `r-` for R packages)

### 5. Create Recipe from Source URL

If the package doesn't exist in official repositories:

#### 5a. For Packages with Releases/Tags
1. Navigate to the package's GitHub page
2. Check `{url}/releases` or `{url}/tags` for available versions
3. Get the source archive URL (typically `.tar.gz` format)
4. Create recipe:

```bash
spack create --skip-editor -b {archive_url}
```

Example URL format: `https://github.com/theislab/scarches/archive/refs/tags/v0.5.1.tar.gz`

#### 5b. For Packages without Releases
1. Clone the repository to a scratch location
2. Get the latest commit SHA
3. Add version using commit date format:

```python
version("20250411", commit="82a307f19fb8188373fdd6838be92d457bf65e06")
```

### 6. Recipe Modification Guidelines

- **Reference Examples**: Use examples in the `examples/` folder to guide you through the structure:
  - `py-agate` for Python packages
  - `r-archr` and `r-plotlistr` for R packages  
  - `samtools` for other packages
- **Add docstring and homepage**
- **Add Build Requirements**: Include all dependencies found in the package documentation in the recipe's `depends_on()` statements. Set all optional dependencies to `True` (avoid using variants)
- **Configure Installation Process**: Adapt the package's installation instructions into appropriate build phases and methods in the recipe
- **Specify Available Versions**: Add all relevant versions and releases with their corresponding checksums to the recipe
- **Include Licence Information**: Add the correct licence declaration based on the package's licence information

### 7. Package Installation

Install the package using Spack:

```bash
spack install {package_name}
```

**Error Handling**: If build errors occur:
1. Read the error logs carefully
2. Fix the recipe based on the error messages
3. Reinstall until successful

### 8. Package Validation

Validate the installation using Singularity:

```bash
singularity exec --bind /mnt/data /home/ubuntu/spack.sif bash -c "source <(/opt/spack/bin/spack load --sh {package_name}); {validation_script}"
```

#### Validation Scripts by Package Type

**R Packages**:
```bash
Rscript -e \"library({package_name})\"
```

**Python Packages**:
```bash
python -c \"import {package_name}\"
```
*Note*: Check PyPI page or package homepage for correct import syntax as it may differ from package name.

**Other Packages**:
Consult the package documentation/webpage for appropriate validation commands.

### 9. Error Resolution

If validation fails:
1. Uninstall the package and dependencies:
   ```bash
   spack uninstall -y --all --dependents {package_name}
   ```
2. Fix the recipe based on error messages
3. Reinstall and revalidate
4. Repeat until successful

### 10. Finalisation

Once validation succeeds:
1. Generate an appropriate commit message (keep it concise - max 2 sentences)
2. Create a branch (don't push to main directly)
3. Commit changes to git
3. Push to repository
4. Create a Pull Request on Github
5. A Github Action is set up to validate the recipe automatically. Once the validation passed, the pull request can be merged)

## Best Practices

- Always read package documentation before creating recipes
- Test thoroughly in the validation step
- Keep commit messages short and descriptive
- Follow existing recipe patterns in the `examples/` folder
- Document any special scenarios and how you resolved them in the troubleshooting.md

## Resources

- [Official Spack documentation](https://spack.readthedocs.io/)
- [PyPI (for Python packages)](https://pypi.org/)
- [CRAN (for R packages)](https://cran.r-project.org/)
- [Bioconductor (for R packages)](https://bioconductor.org/)
- Package homepages and documentation