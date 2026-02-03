# Auto-loaded by Python at startup if it's on sys.path.
# Patch HuggingFace datasets feature type alias: "List" -> "Sequence".
try:
    import datasets.features.features as F
    if "List" not in F._FEATURE_TYPES:
        F._FEATURE_TYPES["List"] = F.Sequence
        # Optional: also support lowercase just in case
        F._FEATURE_TYPES["list"] = F.Sequence
        print("[sitecustomize] Patched datasets: feature type 'List' -> Sequence")
except Exception as e:
    print("[sitecustomize] Patch skipped:", repr(e))
