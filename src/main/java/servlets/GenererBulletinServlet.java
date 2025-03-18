package servlets;

import java.io.*;
import java.math.BigInteger;
import java.text.SimpleDateFormat;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.apache.poi.xwpf.usermodel.*;
import org.apache.poi.xwpf.model.XWPFHeaderFooterPolicy;
import org.apache.poi.util.Units;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.*;

import model.Etudiant;
import model.Matiere;
import model.Note;
import dao.EtudiantDAO;
import dao.MatiereDAO;
import dao.NoteDAO;
import service.MoyenneService;

@WebServlet("/GenererBulletinServlet")
public class GenererBulletinServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Définition des couleurs (format RGB en hexa)
    private static final String COLOR_PRIMARY = "1E3A8A";      // Bleu 
    private static final String COLOR_SECONDARY = "3B82F6";    // Bleu bleu
    private static final String COLOR_SUCCESS = "10B981";      // Vert
    private static final String COLOR_DANGER = "EF4444";       // Rouge 
    private static final String COLOR_WARNING = "F59E0B";      // Orange
    private static final String COLOR_INFO = "3B82F6";         // Bleu info
    private static final String COLOR_LIGHT = "F3F4F6";        // Gris clair
    private static final String COLOR_DARK = "1F2937";         // Gris gris
       
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer les paramètres
        int etudiantId = Integer.parseInt(request.getParameter("etudiantId"));
        int semestre = Integer.parseInt(request.getParameter("semestre"));
        
        try {
            // Récupérer les informations de l'étudiant
            EtudiantDAO etudiantDAO = new EtudiantDAO();
            Etudiant etudiant = etudiantDAO.getEtudiantById(etudiantId);
            
            if (etudiant == null) {
                // Rediriger vers la page des bulletins avec un message d'erreur
                request.getSession().setAttribute("message", "Étudiant introuvable.");
                request.getSession().setAttribute("messageType", "error");
                response.sendRedirect("bulletins.jsp");
                return;
            }
            
            // Utiliser le service de calcul de moyenne
            MoyenneService moyenneService = MoyenneService.getInstance();
            double moyenneGenerale = moyenneService.calculerMoyenneGenerale(etudiantId, semestre);
            
            // Récupérer les notes de l'étudiant
            NoteDAO noteDAO = new NoteDAO();
            List<Note> notes = noteDAO.getAllNotesByEtudiant(etudiantId);
            
            // Filtrer les notes du semestre sélectionné
            List<Note> semestreNotes = new ArrayList<>();
            for (Note note : notes) {
                if (note.getSemestre() == semestre) {
                    semestreNotes.add(note);
                }
            }
            
            // Regrouper les notes par matière
            Map<Integer, List<Note>> notesByMatiere = new HashMap<>();
            for (Note note : semestreNotes) {
                int matiereId = note.getMatiereId();
                if (!notesByMatiere.containsKey(matiereId)) {
                    notesByMatiere.put(matiereId, new ArrayList<>());
                }
                notesByMatiere.get(matiereId).add(note);
            }
            
            // Récupérer les informations des matières
            MatiereDAO matiereDAO = new MatiereDAO();
            
            // Calculer les moyennes par matière
            Map<Integer, Double> moyennesByMatiere = new HashMap<>();
            for (Map.Entry<Integer, List<Note>> entry : notesByMatiere.entrySet()) {
                int matiereId = entry.getKey();
                List<Note> matiereNotes = entry.getValue();
                
                // Calcul de la moyenne de la matière
                double sommeMatiereNotes = 0;
                for (Note note : matiereNotes) {
                    sommeMatiereNotes += note.getValeur();
                }
                double moyenneMatiere = matiereNotes.isEmpty() ? 0 : sommeMatiereNotes / matiereNotes.size();
                moyennesByMatiere.put(matiereId, Math.round(moyenneMatiere * 100.0) / 100.0);
            }
            
            // Génération du document Word
            XWPFDocument document = new XWPFDocument();
            
            // Configurer les marges du document
            CTSectPr sectPr = document.getDocument().getBody().addNewSectPr();
            CTPageMar pageMar = sectPr.addNewPgMar();
            pageMar.setLeft(BigInteger.valueOf(1134L)); // 0.8 marge
            pageMar.setRight(BigInteger.valueOf(1134L)); 
            pageMar.setTop(BigInteger.valueOf(1134L)); 
            pageMar.setBottom(BigInteger.valueOf(1134L)); 
            // Créer l'en-tête
            XWPFHeaderFooterPolicy headerFooterPolicy = document.getHeaderFooterPolicy();
            if (headerFooterPolicy == null) headerFooterPolicy = document.createHeaderFooterPolicy();
            
            XWPFHeader header = headerFooterPolicy.createHeader(XWPFHeaderFooterPolicy.DEFAULT);
            
            // Table pour l'en-tête avec logo et informations
            XWPFTable headerTable = header.createTable(1, 2);
            headerTable.setCellMargins(0, 0, 0, 0);
            
            // Enlever les bordures
            headerTable.getCTTbl().getTblPr().unsetTblBorders();
            
            // Définir les largeurs de colonnes (30% - 70%)
            CTTblWidth headerWidth = headerTable.getCTTbl().addNewTblPr().addNewTblW();
            headerWidth.setType(STTblWidth.DXA);
            headerWidth.setW(BigInteger.valueOf(10000));
            
            headerTable.getRow(0).getCell(0).getCTTc().addNewTcPr().addNewTcW().setW(BigInteger.valueOf(3000));
            headerTable.getRow(0).getCell(1).getCTTc().addNewTcPr().addNewTcW().setW(BigInteger.valueOf(7000));
            
            // Logo et nom de l'école
            XWPFParagraph logoP = headerTable.getRow(0).getCell(0).getParagraphs().get(0);
            logoP.setAlignment(ParagraphAlignment.LEFT);
            XWPFRun logoRun = logoP.createRun();
            logoRun.setText("SkillEdge");
            logoRun.setBold(true);
            logoRun.setFontSize(16);
            logoRun.setColor(COLOR_PRIMARY);
            logoRun.addBreak();
            
            XWPFRun schoolDesc = logoP.createRun();
            schoolDesc.setText("Formation académique d'excellence");
            schoolDesc.setFontSize(10);
            schoolDesc.setColor(COLOR_SECONDARY);
            
            // Informations de l'école
            XWPFParagraph schoolInfoP = headerTable.getRow(0).getCell(1).getParagraphs().get(0);
            schoolInfoP.setAlignment(ParagraphAlignment.RIGHT);
            
            XWPFRun schoolInfo = schoolInfoP.createRun();
            schoolInfo.setText("SkillEdge - École Supérieure");
            schoolInfo.setFontSize(11);
            schoolInfo.setBold(true);
            schoolInfo.addBreak();
            
            XWPFRun addressInfo = schoolInfoP.createRun();
            addressInfo.setText("123 Colobane, Dakar, Sénégal");
            addressInfo.setFontSize(10);
            addressInfo.addBreak();
            
            XWPFRun contactInfo = schoolInfoP.createRun();
            contactInfo.setText("Tel: +221 33 833 33 33 | Email: skilledge@etu.sn");
            contactInfo.setFontSize(10);
            
            // Ligne horizontale sous l'en-tête
            XWPFParagraph headerLine = document.createParagraph();
            XWPFRun headerLineRun = headerLine.createRun();
            headerLineRun.addBreak();
            
            // Créer une bordure en bas du paragraphe
            headerLine.getCTP().addNewPPr().addNewPBdr().addNewBottom().setVal(STBorder.SINGLE);
            headerLine.getCTP().getPPr().getPBdr().getBottom().setSz(BigInteger.valueOf(8));
            headerLine.getCTP().getPPr().getPBdr().getBottom().setColor(COLOR_SECONDARY);
            
            // Titre du document avec couleur
            XWPFParagraph titleParagraph = document.createParagraph();
            titleParagraph.setAlignment(ParagraphAlignment.CENTER);
            titleParagraph.setSpacingAfter(300); // Espace après le titre
            
            XWPFRun titleRun = titleParagraph.createRun();
            titleRun.setText("BULLETIN DE NOTES");
            titleRun.setBold(true);
            titleRun.setFontSize(18);
            titleRun.setColor(COLOR_PRIMARY);
            titleRun.addBreak();
            
            XWPFRun subtitleRun = titleParagraph.createRun();
            subtitleRun.setText("Semestre " + semestre + " - Année Académique 2024-2025");
            subtitleRun.setFontSize(12);
            subtitleRun.setColor(COLOR_SECONDARY);
            
            // Informations de l'étudiant avec style amélioré
            XWPFParagraph infoParagraph = document.createParagraph();
            infoParagraph.setAlignment(ParagraphAlignment.LEFT);
            infoParagraph.setSpacingBefore(300);
            
            // Titre avec fond coloré
            XWPFRun infoRun = infoParagraph.createRun();
            infoRun.setText("  INFORMATIONS DE L'ÉTUDIANT  ");
            infoRun.setBold(true);
            infoRun.setFontSize(11);
            infoRun.setColor("FFFFFF"); // Blanc
            infoRun.setTextHighlightColor("blue");
            
            // Table d'informations de l'étudiant avec couleurs et style amélioré
            XWPFTable infoTable = document.createTable(3, 2);
            
            // Style de la table
            infoTable.setWidth("100%");
            infoTable.setCellMargins(100, 200, 100, 200);
            
            // Personnaliser les cellules
            XWPFTableRow row1 = infoTable.getRow(0);
            XWPFTableCell cell1_1 = row1.getCell(0);
            XWPFTableCell cell1_2 = row1.getCell(1);
            
            // Style pour les cellules d'en-tête
            cell1_1.setColor(COLOR_LIGHT);
            XWPFParagraph cell1_1P = cell1_1.getParagraphs().get(0);
            XWPFRun cell1_1Run = cell1_1P.createRun();
            cell1_1Run.setText("Nom et Prénom:");
            cell1_1Run.setBold(true);
            cell1_1Run.setColor(COLOR_DARK);
            
            // Valeur avec couleur
            XWPFParagraph cell1_2P = cell1_2.getParagraphs().get(0);
            XWPFRun cell1_2Run = cell1_2P.createRun();
            cell1_2Run.setText(etudiant.getNom() + " " + etudiant.getPrenom());
            cell1_2Run.setBold(true);
            cell1_2Run.setColor(COLOR_PRIMARY);
            
            // Deuxième ligne
            XWPFTableRow row2 = infoTable.getRow(1);
            XWPFTableCell cell2_1 = row2.getCell(0);
            XWPFTableCell cell2_2 = row2.getCell(1);
            
            cell2_1.setColor(COLOR_LIGHT);
            XWPFParagraph cell2_1P = cell2_1.getParagraphs().get(0);
            XWPFRun cell2_1Run = cell2_1P.createRun();
            cell2_1Run.setText("Filière:");
            cell2_1Run.setBold(true);
            cell2_1Run.setColor(COLOR_DARK);
            
            XWPFParagraph cell2_2P = cell2_2.getParagraphs().get(0);
            XWPFRun cell2_2Run = cell2_2P.createRun();
            cell2_2Run.setText(etudiant.getFiliere());
            cell2_2Run.setColor(COLOR_SECONDARY);
            
            // Troisième ligne
            XWPFTableRow row3 = infoTable.getRow(2);
            XWPFTableCell cell3_1 = row3.getCell(0);
            XWPFTableCell cell3_2 = row3.getCell(1);
            
            cell3_1.setColor(COLOR_LIGHT);
            XWPFParagraph cell3_1P = cell3_1.getParagraphs().get(0);
            XWPFRun cell3_1Run = cell3_1P.createRun();
            cell3_1Run.setText("Niveau:");
            cell3_1Run.setBold(true);
            cell3_1Run.setColor(COLOR_DARK);
            
            XWPFParagraph cell3_2P = cell3_2.getParagraphs().get(0);
            XWPFRun cell3_2Run = cell3_2P.createRun();
            cell3_2Run.setText(etudiant.getNiveau());
            cell3_2Run.setColor(COLOR_SECONDARY);
            
            // Ajouter de l'espace
            XWPFParagraph spacer = document.createParagraph();
            spacer.createRun().addBreak();
            
            // Tableau des notes avec style amélioré
            XWPFParagraph notesParagraph = document.createParagraph();
            notesParagraph.setAlignment(ParagraphAlignment.LEFT);
            
            // Titre avec fond coloré
            XWPFRun notesRun = notesParagraph.createRun();
            notesRun.setText("  RELEVÉ DES NOTES  ");
            notesRun.setBold(true);
            notesRun.setFontSize(11);
            notesRun.setColor("FFFFFF"); // Blanc
            notesRun.setTextHighlightColor("blue");
            
            // Création du tableau des notes
            XWPFTable notesTable = document.createTable(notesByMatiere.size() + 2, 4); // +1 pour l'en-tête, +1 pour la moyenne générale
            notesTable.setWidth("100%");
            
            // En-tête du tableau avec fond bleu
            XWPFTableRow headerRow = notesTable.getRow(0);
            
            // Style de l'en-tête
            for (int i = 0; i < 4; i++) {
                XWPFTableCell cell = headerRow.getCell(i);
                cell.setColor(COLOR_SECONDARY);
                
                XWPFParagraph paragraph = cell.getParagraphs().get(0);
                paragraph.setAlignment(ParagraphAlignment.CENTER);
                
                XWPFRun run = paragraph.createRun();
                run.setBold(true);
                run.setColor("FFFFFF"); // Blanc
                
                switch (i) {
                    case 0: run.setText("Matière"); break;
                    case 1: run.setText("Coefficient"); break;
                    case 2: run.setText("Moyenne"); break;
                    case 3: run.setText("Observation"); break;
                }
            }
            
            // Remplir le tableau avec les notes et appliquer des styles
            int rowIndex = 1;
            boolean alternateColor = false;
            
            for (Map.Entry<Integer, List<Note>> entry : notesByMatiere.entrySet()) {
                int matiereId = entry.getKey();
                Matiere matiere = matiereDAO.getMatiereById(matiereId);
                if (matiere == null) continue;
                
                Double moyenneMatiere = moyennesByMatiere.get(matiereId);
                if (moyenneMatiere == null) moyenneMatiere = 0.0;
                
                XWPFTableRow row = notesTable.getRow(rowIndex);
                
                // Appliquer une couleur de fond alternée
                if (alternateColor) {
                    for (int i = 0; i < 4; i++) {
                        row.getCell(i).setColor(COLOR_LIGHT);
                    }
                }
                alternateColor = !alternateColor;
                
                // Nom de la matière
                XWPFParagraph cell0P = row.getCell(0).getParagraphs().get(0);
                XWPFRun cell0Run = cell0P.createRun();
                cell0Run.setText(matiere.getNom());
                cell0Run.setBold(true);
                cell0Run.setColor(COLOR_PRIMARY);
                
                // Coefficient
                XWPFParagraph cell1P = row.getCell(1).getParagraphs().get(0);
                cell1P.setAlignment(ParagraphAlignment.CENTER);
                XWPFRun cell1Run = cell1P.createRun();
                cell1Run.setText(String.valueOf(matiere.getCoefficient()));
                
                // Moyenne
                XWPFParagraph cell2P = row.getCell(2).getParagraphs().get(0);
                cell2P.setAlignment(ParagraphAlignment.CENTER);
                XWPFRun cell2Run = cell2P.createRun();
                cell2Run.setText(String.format("%.2f/20", moyenneMatiere));
                
                // Couleur selon la note
                if (moyenneMatiere >= 10) {
                    cell2Run.setColor(moyenneMatiere >= 14 ? COLOR_SUCCESS : COLOR_INFO);
                } else {
                    cell2Run.setColor(COLOR_DANGER);
                }
                cell2Run.setBold(true);
                
                // Observation
                XWPFParagraph cell3P = row.getCell(3).getParagraphs().get(0);
                XWPFRun cell3Run = cell3P.createRun();
                
                // Observation basée sur la moyenne
                String observation = "";
                String obsColor = COLOR_DARK;
                if (moyenneMatiere >= 16) {
                    observation = "Très bien";
                    obsColor = COLOR_SUCCESS;
                } else if (moyenneMatiere >= 14) {
                    observation = "Bien";
                    obsColor = COLOR_SUCCESS;
                } else if (moyenneMatiere >= 12) {
                    observation = "Assez bien";
                    obsColor = COLOR_INFO;
                } else if (moyenneMatiere >= 10) {
                    observation = "Passable";
                    obsColor = COLOR_WARNING;
                } else {
                    observation = "Insuffisant";
                    obsColor = COLOR_DANGER;
                }
                
                cell3Run.setText(observation);
                cell3Run.setColor(obsColor);
                
                rowIndex++;
            }
            
            // Ligne de la moyenne générale avec couleur de fond
            XWPFTableRow moyenneRow = notesTable.getRow(rowIndex);
            
            // Fond gris pour la ligne de moyenne
            for (int i = 0; i < 4; i++) {
                moyenneRow.getCell(i).setColor(COLOR_DARK);
            }
            
            // Fusionner les deux premières cellules
            moyenneRow.getCell(0).getCTTc().addNewTcPr().addNewGridSpan().setVal(BigInteger.valueOf(2));
            
            // MOYENNE GÉNÉRALE
            XWPFParagraph moyenneP = moyenneRow.getCell(0).getParagraphs().get(0);
            XWPFRun moyenneRun = moyenneP.createRun();
            moyenneRun.setText("MOYENNE GÉNÉRALE");
            moyenneRun.setBold(true);
            moyenneRun.setColor("FFFFFF"); // Blanc
            
            // Valeur moyenne
            XWPFParagraph valeurP = moyenneRow.getCell(2).getParagraphs().get(0);
            valeurP.setAlignment(ParagraphAlignment.CENTER);
            XWPFRun valeurRun = valeurP.createRun();
            valeurRun.setText(String.format("%.2f/20", moyenneGenerale));
            valeurRun.setBold(true);
            valeurRun.setColor("FFFFFF"); // Blanc
            
            // Observation générale
            String observationGenerale = "";
            if (moyenneGenerale >= 16) {
                observationGenerale = "EXCELLENT";
            } else if (moyenneGenerale >= 14) {
                observationGenerale = "TRÈS BIEN";
            } else if (moyenneGenerale >= 12) {
                observationGenerale = "BIEN";
            } else if (moyenneGenerale >= 10) {
                observationGenerale = "PASSABLE";
            } else {
                observationGenerale = "INSUFFISANT";
            }
            
            XWPFParagraph obsP = moyenneRow.getCell(3).getParagraphs().get(0);
            XWPFRun obsRun = obsP.createRun();
            obsRun.setText(observationGenerale);
            obsRun.setBold(true);
            obsRun.setColor("FFFFFF"); // Blanc
            
            // Espace après le tableau
            XWPFParagraph spacer2 = document.createParagraph();
            spacer2.createRun().addBreak();
            spacer2.createRun().addBreak();
            
            // Box de décision
            XWPFTable decisionTable = document.createTable(1, 1);
            decisionTable.setWidth("100%");
            
            // Style de la cellule de décision
            XWPFTableCell decisionCell = decisionTable.getRow(0).getCell(0);
            decisionCell.setColor(moyenneGenerale >= 10 ? COLOR_SUCCESS : COLOR_DANGER);
            
            // Texte de décision
            XWPFParagraph decisionP = decisionCell.getParagraphs().get(0);
            decisionP.setAlignment(ParagraphAlignment.CENTER);
            
            XWPFRun decisionLabelRun = decisionP.createRun();
            decisionLabelRun.setText("DÉCISION DU JURY: ");
            decisionLabelRun.setBold(true);
            decisionLabelRun.setColor("FFFFFF"); // Blanc
            decisionLabelRun.setFontSize(11);
            
            XWPFRun decisionValueRun = decisionP.createRun();
            String decision = moyenneGenerale >= 10 ? "ADMIS(E)" : "AJOURNÉ(E)";
            decisionValueRun.setText(decision);
            decisionValueRun.setBold(true);
            decisionValueRun.setFontSize(14);
            decisionValueRun.setColor("FFFFFF"); // Blanc
            
            // Date et signature
            XWPFParagraph dateParagraph = document.createParagraph();
            dateParagraph.setAlignment(ParagraphAlignment.RIGHT);
            dateParagraph.setSpacingBefore(600);
            
            XWPFRun dateRun = dateParagraph.createRun();
            
            SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy");
            String dateActuelle = sdf.format(new Date());
            
            dateRun.setText("Fait à Dakar, le " + dateActuelle);
            dateRun.setFontSize(11);
            dateRun.setItalic(true);
            dateRun.addBreak();
            dateRun.addBreak();
            
            XWPFRun signatureRun = dateParagraph.createRun();
            signatureRun.setText("La Directrice");
            signatureRun.setFontSize(11);
            signatureRun.addBreak();
            signatureRun.addBreak();
            signatureRun.addBreak();
            
            XWPFRun signatureNameRun = dateParagraph.createRun();
            signatureNameRun.setText("Dr. Amina NIASSE");
            signatureNameRun.setFontSize(11);
            signatureNameRun.setBold(true);
            signatureNameRun.setColor(COLOR_PRIMARY);
            
            // Pied de page
            XWPFFooter footer = headerFooterPolicy.createFooter(XWPFHeaderFooterPolicy.DEFAULT);
            XWPFParagraph footerParagraph = footer.createParagraph();
            footerParagraph.setAlignment(ParagraphAlignment.CENTER);
            XWPFRun footerRun = footerParagraph.createRun();
            footerRun.setText("SkillEdge - Système de Gestion Scolaire | Ce document est généré automatiquement.");
            footerRun.setFontSize(8);
            footerRun.setColor("808080");
            
            // Configurer la réponse HTTP
            response.setContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
            String fileName = "Bulletin_" + etudiant.getNom() + "_" + etudiant.getPrenom() + "_S" + semestre + ".docx";
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            
            // Écrire le document dans le flux de sortie
            OutputStream out = response.getOutputStream();
            document.write(out);
            out.flush();
            out.close();
            document.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            // Rediriger vers la page des bulletins avec un message d'erreur
            request.getSession().setAttribute("message", "Erreur lors de la génération du bulletin: " + e.getMessage());
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect("bulletins.jsp");
        }
    }
}