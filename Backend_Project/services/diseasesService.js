const fs = require('fs');
const path = require('path');

const diseasesFilePath = path.join('Backend_Project\data\diseases.js');

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



