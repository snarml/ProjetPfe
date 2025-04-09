const fs = require('fs');
const path = require('path');

const diseasesFilePath = path.join(__dirname, '../data/diseases.json');

const getAllDiseases = () => {
    const data = fs.readFileSync(diseasesFilePath);
    return JSON.parse(data);
};

const getDiseaseById = (id) => {
    const diseases = getAllDiseases();
    return diseases.find(d => d.id === id);
};

module.exports = {
    getAllDiseases,
    getDiseaseById
};
