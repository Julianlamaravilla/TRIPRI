#!/bin/bash
# Setup script para instalar commitlint y validación de commits en TRIPRI

set -e

echo "🔧 Instalando commitlint y husky..."

# Instalar dependencias
npm install --save-dev @commitlint/config-conventional @commitlint/cli husky

# Inicializar husky
npx husky install

# Crear hook de pre-commit para commitlint
npx husky add .husky/commit-msg 'npx --no -- commitlint --edit "$1"'

echo "✅ commitlint instalado exitosamente"
echo ""
echo "📝 Próximos pasos:"
echo "  1. Haz un commit de prueba: git commit -m 'feat(test): verify commitlint'"
echo "  2. Deberías ver validación de mensaje de commit"
echo "  3. Si algo falla, revisa la salida y ajusta el mensaje según CONVENTIONAL_COMMITS.md"
echo ""
echo "🚀 Para saltar validación en casos excepcionales (no lo hagas habitualmente):"
echo "   git commit --no-verify"
echo ""
