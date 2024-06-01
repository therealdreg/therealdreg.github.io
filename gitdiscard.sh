#!/bin/bash

# Guardar el commit anterior como base
base_commit=HEAD~1

# Iterar sobre cada extensión de archivo proporcionada como argumento
for ext in "$@"
do
    echo "Procesando archivos con extensión $ext"

    # Encontrar archivos modificados y añadidos con la extensión dada
    modified_files=$(git diff --name-only --diff-filter=AM $base_commit HEAD -- "*.$ext")
    if [ -n "$modified_files" ]; then
        echo "Revertiendo cambios en archivos modificados y añadidos:"
        echo "$modified_files"
        echo "$modified_files" | xargs -I {} git checkout $base_commit -- {}
    else
        echo "No hay archivos modificados o nuevos para revertir con extensión .$ext"
    fi
done

# Verificar si hay cambios para hacer commit
if git diff --cached --quiet; then
    echo "No hay cambios para hacer commit."
else
    git commit -m "Reverted changes for specified extensions"
    echo "Cambios revertidos para las extensiones proporcionadas."
fi
