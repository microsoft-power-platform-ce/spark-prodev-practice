const { readFile, readdir, writeFile } = require("fs/promises");
const { join } = require("path");
const { cwd } = require("process");

const settingsFilePrefix = "config";

const getSolutionFolder = () => process.argv.slice(2)[0];
const listEnvironmentSettingsFilesInFolder =
  (solutionFolder) => async (templateFileName) =>
    (await readdir(join(cwd(), solutionFolder))).filter(
      (fileName) =>
        fileName !== templateFileName &&
        fileName.match(`^${settingsFilePrefix}.*\.json$`)
    );
const readSettingsFileInFolder = (solutionFolder) => async (fileName) => {
  const buffer = await readFile(join(solutionFolder, fileName));
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
  const listEnvironmentSettingsFiles =
    listEnvironmentSettingsFilesInFolder(solutionFolder);
  const readSettingsFile = readSettingsFileInFolder(solutionFolder);

  const templateFileName = `${settingsFilePrefix}.json`;
  const template = await readSettingsFile(templateFileName);
  const applyEnvironmentSettings = applyEnvironmentSettingsToTemplate(template);

  const environmentFileNames = await listEnvironmentSettingsFiles(
    templateFileName
  );
  await Promise.all(
    environmentFileNames.map(async (fileName) => {
      const environmentSettings = await readSettingsFile(fileName);
      const newEnvironmentSettings =
        applyEnvironmentSettings(environmentSettings);
      await writeFile(
        join(solutionFolder, fileName),
        JSON.stringify(newEnvironmentSettings, null, "  ")
      );
    })
  );
})().catch(console.error);
