const { readFile, readdir, writeFile } = require("fs/promises");
const { join } = require("path");
const { cwd } = require("process");

const settingsFilePrefix = "config";
const templateFileName = `${settingsFilePrefix}.json`;
const environments = ["prod", "prod-gh"];

const getSolutionFolder = () => process.argv.slice(2)[0];
const listEnvironmentSettingsFiles = () =>
  environments.map(
    (environment) => `${settingsFilePrefix}.${environment}.json`
  );
const readSettingsFileInFolder = (solutionFolder) => async (fileName) => {
  const buffer = await readFile(join(cwd(), solutionFolder, fileName));
  const contents = buffer.toString();
  const template = JSON.parse(contents);
  return template;
};
const mergeArrays = (template, instance, key) =>
  template.map(
    (templateItem) =>
      instance.find(
        (instanceItem) => instanceItem[key] === templateItem[key]
      ) ?? templateItem
  );
const applyEnvironmentSettingsToTemplate =
  (template) => (environmentSettings) => ({
    EnvironmentVariables: mergeArrays(
      template.EnvironmentVariables,
      environmentSettings.EnvironmentVariables,
      "SchemaName"
    ),
    ConnectionReferences: mergeArrays(
      template.ConnectionReferences,
      environmentSettings.ConnectionReferences,
      "LogicalName"
    ),
  });

(async () => {
  const solutionFolder = getSolutionFolder();
  const environmentFileNames = listEnvironmentSettingsFiles();
  const readSettingsFile = readSettingsFileInFolder(solutionFolder);

  const template = await readSettingsFile(templateFileName);
  const applyEnvironmentSettings = applyEnvironmentSettingsToTemplate(template);

  await Promise.all(
    environmentFileNames.map(async (fileName) => {
      try {
        const environmentSettings = await readSettingsFile(fileName);
        const newEnvironmentSettings =
          applyEnvironmentSettings(environmentSettings);
        await writeFile(
          join(cwd(), solutionFolder, fileName),
          JSON.stringify(newEnvironmentSettings, null, "  ")
        );
      } catch {
        await writeFile(
          join(cwd(), solutionFolder, fileName),
          JSON.stringify(template, null, "  ")
        );
      }
    })
  );
})().catch(console.error);
