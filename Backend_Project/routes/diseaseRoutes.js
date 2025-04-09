const express = require('express');
const router = express.Router();
const diseaseController = require('Backend_Project\Controllers\diseaseController.js');

router.get('/diseases', diseaseController.getDiseases);
router.get('/diseases/:id', diseaseController.getDiseaseById);

module.exports = router;
