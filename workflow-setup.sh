#!/usr/bin/env bash
set -euo pipefail

mkdir -p config

build_number="${GITHUB_RUN_NUMBER:-local}.${GITHUB_RUN_ATTEMPT:-1}"
build_date="$(date -u '+%Y-%m-%d %H:%M UTC')"
build_commit="$(printf '%s' "${GITHUB_SHA:-local}" | cut -c1-7)"

cat > config/build-info.tex <<EOF
\UASetBuildNumber{${build_number}}
\UASetBuildDate{${build_date}}
\UASetBuildCommit{${build_commit}}
EOF

echo "Workflow setup complete: build ${build_number} (${build_date}, ${build_commit})."
