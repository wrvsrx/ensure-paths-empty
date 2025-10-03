def main : IO Unit := do
  let files ← System.FilePath.readDir "."
  for file in files do
    IO.println file.fileName
