const diseaseService = require('../services/diseaseService');

const getDiseases = (req, res) => {
    const diseases = diseaseService.getAllDiseases();
    res.json(diseases);
};

const getDiseaseById = (req, res) => {
    const id = parseInt(req.params.id);
    const disease = diseaseService.getDiseaseById(id);
    if (disease) {
        res.json(disease);
    } else {
        res.status(404).json({ message: 'المرض هذا ما لقيناهش' });
    }
};

module.exports = {
    getDiseases,
    getDiseaseById
};
