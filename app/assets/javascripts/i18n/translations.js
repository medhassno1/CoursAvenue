var I18n = I18n || {};
I18n.translations = {"en":{"date":{"formats":{"default":"%Y-%m-%d","short":"%b %d","long":"%B %d, %Y"},"day_names":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],"abbr_day_names":["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],"month_names":[null,"January","February","March","April","May","June","July","August","September","October","November","December"],"abbr_month_names":[null,"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"order":["year","month","day"]},"time":{"formats":{"default":"%a, %d %b %Y %H:%M:%S %z","short":"%d %b %H:%M","long":"%B %d, %Y %H:%M"},"am":"am","pm":"pm"},"support":{"array":{"words_connector":", ","two_words_connector":" and ","last_word_connector":", and "}},"number":{"format":{"separator":".","delimiter":",","precision":3,"significant":false,"strip_insignificant_zeros":false},"currency":{"format":{"format":"%u%n","unit":"$","separator":".","delimiter":",","precision":2,"significant":false,"strip_insignificant_zeros":false}},"percentage":{"format":{"delimiter":"","format":"%n%"}},"precision":{"format":{"delimiter":""}},"human":{"format":{"delimiter":"","precision":3,"significant":true,"strip_insignificant_zeros":true},"storage_units":{"format":"%n %u","units":{"byte":{"one":"Byte","other":"Bytes"},"kb":"KB","mb":"MB","gb":"GB","tb":"TB"}},"decimal_units":{"format":"%n %u","units":{"unit":"","thousand":"Thousand","million":"Million","billion":"Billion","trillion":"Trillion","quadrillion":"Quadrillion"}}}},"errors":{"format":"%{attribute} %{message}","messages":{"inclusion":"is not included in the list","exclusion":"is reserved","invalid":"is invalid","confirmation":"doesn't match %{attribute}","accepted":"must be accepted","empty":"can't be empty","blank":"can't be blank","present":"must be blank","too_long":"is too long (maximum is %{count} characters)","too_short":"is too short (minimum is %{count} characters)","wrong_length":"is the wrong length (should be %{count} characters)","not_a_number":"is not a number","not_an_integer":"must be an integer","greater_than":"must be greater than %{count}","greater_than_or_equal_to":"must be greater than or equal to %{count}","equal_to":"must be equal to %{count}","less_than":"must be less than %{count}","less_than_or_equal_to":"must be less than or equal to %{count}","other_than":"must be other than %{count}","odd":"must be odd","even":"must be even","taken":"has already been taken","in_between":"must be in between %{min} and %{max}","already_confirmed":"was already confirmed, please try signing in","confirmation_period_expired":"needs to be confirmed within %{period}, please request a new one","expired":"has expired, please request a new one","not_found":"not found","not_locked":"was not locked","not_saved":{"one":"1 error prohibited this %{resource} from being saved:","other":"%{count} errors prohibited this %{resource} from being saved:"}}},"activerecord":{"errors":{"messages":{"record_invalid":"Validation failed: %{errors}","restrict_dependent_destroy":{"one":"Cannot delete record because a dependent %{record} exists","many":"Cannot delete record because dependent %{record} exist"}}}},"datetime":{"distance_in_words":{"half_a_minute":"half a minute","less_than_x_seconds":{"one":"less than 1 second","other":"less than %{count} seconds"},"x_seconds":{"one":"1 second","other":"%{count} seconds"},"less_than_x_minutes":{"one":"less than a minute","other":"less than %{count} minutes"},"x_minutes":{"one":"1 minute","other":"%{count} minutes"},"about_x_hours":{"one":"about 1 hour","other":"about %{count} hours"},"x_days":{"one":"1 day","other":"%{count} days"},"about_x_months":{"one":"about 1 month","other":"about %{count} months"},"x_months":{"one":"1 month","other":"%{count} months"},"about_x_years":{"one":"about 1 year","other":"about %{count} years"},"over_x_years":{"one":"over 1 year","other":"over %{count} years"},"almost_x_years":{"one":"almost 1 year","other":"almost %{count} years"}},"prompts":{"year":"Year","month":"Month","day":"Day","hour":"Hour","minute":"Minute","second":"Seconds"}},"helpers":{"select":{"prompt":"Please select"},"submit":{"create":"Create %{model}","update":"Update %{model}","submit":"Save %{model}"},"page_entries_info":{"one_page":{"display_entries":{"zero":"No %{entry_name} found","one":"Displaying \u003Cb\u003E1\u003C/b\u003E %{entry_name}","other":"Displaying \u003Cb\u003Eall %{count}\u003C/b\u003E %{entry_name}"}},"more_pages":{"display_entries":"Displaying %{entry_name} \u003Cb\u003E%{first}\u0026nbsp;-\u0026nbsp;%{last}\u003C/b\u003E of \u003Cb\u003E%{total}\u003C/b\u003E in total"}}},"flash":{"actions":{"create":{"notice":"%{resource_name} was successfully created."},"update":{"notice":"%{resource_name} was successfully updated."},"destroy":{"notice":"%{resource_name} was successfully destroyed.","alert":"%{resource_name} could not be destroyed."}}},"views":{"pagination":{"first":"\u0026laquo; First","last":"Last \u0026raquo;","previous":"\u0026lsaquo; Prev","next":"Next \u0026rsaquo;","truncate":"\u0026hellip;"}},"devise":{"confirmations":{"confirmed":"Your account was successfully confirmed. You are now signed in.","confirmed_and_signed_in":"Your account was successfully confirmed. You are now signed in.","send_instructions":"You will receive an email with instructions about how to confirm your account in a few minutes.","send_paranoid_instructions":"If your email address exists in our database, you will receive an email with instructions about how to confirm your account in a few minutes."},"failure":{"already_authenticated":"You are already signed in.","inactive":"Your account was not activated yet.","invalid":"Invalid email or password.","invalid_token":"Invalid authentication token.","locked":"Your account is locked.","not_found_in_database":"Invalid email or password.","timeout":"Your session expired, please sign in again to continue.","unauthenticated":"You need to sign in or sign up before continuing.","unconfirmed":"You have to confirm your account before continuing."},"mailer":{"confirmation_instructions":{"subject":"Confirmation instructions"},"reset_password_instructions":{"subject":"Reset password instructions"},"unlock_instructions":{"subject":"Unlock Instructions"},"invitation_instructions":{"subject":"Invitation instructions"}},"omniauth_callbacks":{"failure":"Could not authenticate you from %{kind} because \"%{reason}\".","success":"Successfully authenticated from %{kind} account."},"passwords":{"no_token":"You can't access this page without coming from a password reset email. If you do come from a password reset email, please make sure you used the full URL provided.","send_instructions":"You will receive an email with instructions about how to reset your password in a few minutes.","send_paranoid_instructions":"If your email address exists in our database, you will receive a password recovery link at your email address in a few minutes.","updated":"Your password was changed successfully. You are now signed in.","updated_not_active":"Your password was changed successfully."},"registrations":{"destroyed":"Bye! Your account was successfully cancelled. We hope to see you again soon.","signed_up":"Welcome! You have signed up successfully.","signed_up_but_inactive":"You have signed up successfully. However, we could not sign you in because your account is not yet activated.","signed_up_but_locked":"You have signed up successfully. However, we could not sign you in because your account is locked.","signed_up_but_unconfirmed":"A message with a confirmation link has been sent to your email address. Please open the link to activate your account.","update_needs_confirmation":"You updated your account successfully, but we need to verify your new email address. Please check your email and click on the confirm link to finalize confirming your new email address.","updated":"You updated your account successfully."},"sessions":{"signed_in":"Signed in successfully.","signed_out":"Signed out successfully."},"unlocks":{"send_instructions":"You will receive an email with instructions about how to unlock your account in a few minutes.","send_paranoid_instructions":"If your account exists, you will receive an email with instructions about how to unlock it in a few minutes.","unlocked":"Your account has been unlocked successfully. Please sign in to continue."},"invitations":{"send_instructions":"An invitation email has been sent to %{email}.","invitation_token_invalid":"The invitation token provided is not valid!","updated":"Your password was set successfully. You are now signed in.","no_invitations_remaining":"No invitations remaining","new":{"header":"Send invitation","submit_button":"Send an invitation"},"edit":{"header":"Set your password","submit_button":"Set my password"}}},"hello":"Hello world","simple_form":{"yes":"Yes","no":"No","required":{"text":"required","mark":"*"},"error_notification":{"default_message":"Please review the problems below:"}}},"fr":{"activerecord":{"models":{"course":"Cours","admin":"Prof","audience":"Public","book_ticket":"Carnet de ticket","city":"Ville","comment":"Avis","contact":"Contact","course/training":"Stage","course/lesson":"Cours","course/workshop":"Cours-atelier","level":"Niveau","location":"Lieu","media":{"zero":"Média","one":"Média","other":"Médias"},"place":{"zero":"Lieu","one":"Lieu","other":"Lieux"},"planning":"Planning","price":"Tarif","registration_fee":"Frais d'adhésion","reservation":"Reservation","room":"Salle","structure":"établissements","subject":"Discipline","teacher":{"zero":"Professeur","one":"Professeur","other":"Professeurs"},"user":"Élève"},"attributes":{"registration_fee":{"kid_registration_fee":"Prix d'adhésion pour enfants :","registration_fee":"Prix d'adhésion :","info":"Info","amount":"Prix"},"admin":{"civility":"Civilité","name":"Prénom + Nom","phone_number":"Téléphone","mobile_phone_number":"Téléphone portable","email":"E-mail","password":"Mot de passe","password_confirmation":"Confirmation du mot de passe","remember_me":"Se souvenir de moi","role":"Fonction","is_teacher":"Je suis professeur"},"book_ticket":{"number":"Nombre de ticket","price":"Prix","validity":"Validité (en mois)"},"city":null,"comment":{"content":"Votre avis","title":"Titre de votre avis","course_name":"Nom du cours suivi","name":"Nom","email":"Votre email (non visible)","rating":"Votre appréciation","author_name":"Votre nom (visible)"},"contact":{"name":"Nom","email":"Email","phone":"Téléphone","mobile_phone":"Téléphone portable"},"course":{"description":"Description","name":"Nom","teacher":"Professeur","max_age_for_kid":"Age max","min_age_for_kid":"Age min","is_individual":"Individuel / Particulier","is_for_handicaped":"Pour handicapés","frequency":"Fréquence","room":"Salle de cours principale","price_details":"Autres tarifs / Informations","place":"Lieu","image":"Image du cours","cant_be_joined_during_year":"Inscriptions non acceptées en cours d'année","no_class_during_holidays":"Pas de cours pendant les vacances scolaires","subjects":"Disciplines"},"location":{"name":"Nom","street":"Adresse (N° + rue)","zip_code":"Code postal","city":"Ville"},"media":{"url":"\u003Ci class=\"icon-link\"\u003E\u003C/i\u003E\u0026nbsp;Lien video / image","caption":"Légende"},"place":{"name":"Nom","street":"Adresse (N° + rue)","zip_code":"Code postal","city":"Ville","info":"Indications","nb_room":"Nombre de salles","contact_email":"Email","contact_name":"Nom","contact_phone":"Téléphone","contact_mobile_phone":"Téléphone portable"},"planning":{"place":"Lieu","duration":"Durée","end_date":"Date de fin","start_date":"Date de début","start_time":"Heure de début","end_time":"Heure de fin","week_day":"Jour de la semaine","class_during_holidays":null,"nb_place_available":null,"promotion":null,"info":"Information","min_age_for_kid":null,"max_age_for_kid":null,"room":"Salle","teacher":"Professeur"},"price":{"libelle":"Type","amount":"Montant"},"reservation":{"name":"Nom","email":"Email","billing_address_first_line":"Adresse ligne 1","billing_address_second_line":"Adresse ligne 2","name_on_card":"Nom sur la carte","city_name":"Ville","zip_code":"Code postal","phone":"Téléphone","nb_participants":"Nombre de participants"},"room":{"name":"Nom","surface":"Superficie (approximative en m2)"},"structure":{"name":"Nom","structure_type":"Type d'établissement","nb_room":"Nombre de salles","street":"Adresse","zip_code":"Code postal","city":"Ville","website":"Site internet","facebook_url":"Page facebook","has_handicap_access":"Accès handicapés","contact_phone":"Téléphone fixe","contact_mobile_phone":"Téléphone portable","contact_email":"Email","email_address":"Adresse email","funding_types":"Type de financements acceptés","gives_professional_courses":"Mes cours sont pour des professionnels","billing_contact_first_name":"Prénom","billing_contact_last_name":"Nom","billing_contact_phone_number":"Numéro de téléphone","billing_contact_email":"Email","siret":"N° SIRET","tva_intracom_number":"N° TVA Intracommunautaire","structure_status":"Statuts","bank_name":"Nom de la banque","bank_iban":"IBAN","bank_bic":"Identifiant bancaire (BIC)","cancel_condition":"Conditions d’annulation","modification_condition":"Conditions de modification","teaches_at_home":"Cours à domicile","widget_url":"Lien vers votre livre d'or","widget_status":"Avez-vous installé votre widget"},"subject":null,"teacher":{"name":"Prénom + Nom","description":"Description"},"user":{"first_name":"Prénom","last_name":"Nom"}},"errors":{"format":"%{attribute} %{message}","messages":{"inclusion":"n'est pas inclus(e) dans la liste","exclusion":"n'est pas disponible","invalid":"n'est pas valide","confirmation":"ne concorde pas avec la confirmation","accepted":"doit être accepté(e)","empty":"doit être rempli(e)","blank":"doit être rempli(e)","too_long":{"one":"est trop long (pas plus d'un caractère)","other":"est trop long (pas plus de %{count} caractères)"},"too_short":{"one":"est trop court (au moins un caractère)","other":"est trop court (au moins %{count} caractères)"},"wrong_length":{"one":"ne fait pas la bonne longueur (doit comporter un seul caractère)","other":"ne fait pas la bonne longueur (doit comporter %{count} caractères)"},"not_a_number":"n'est pas un nombre","not_an_integer":"doit être un nombre entier","greater_than":"doit être supérieur à %{count}","greater_than_or_equal_to":"doit être supérieur ou égal à %{count}","equal_to":"doit être égal à %{count}","less_than":"doit être inférieur à %{count}","less_than_or_equal_to":"doit être inférieur ou égal à %{count}","odd":"doit être impair","even":"doit être pair","taken":"n'est pas disponible","record_invalid":"La validation a échoué : %{errors}"},"template":{"header":{"one":"Impossible d'enregistrer ce(tte) %{model} : 1 erreur","other":"Impossible d'enregistrer ce(tte) %{model} : %{count} erreurs"},"body":"Veuillez vérifier les champs suivants : "}}},"civility":{"male":"Monsieur","female":"Madame"},"pro":{"admins":{"registrations":{"successful":"Merci de vous être enregistré ! Bienvenue dans votre espace de configuration.","new":{"email":"Email","phone_number_info":"En cas de besoin, nous vous contacterons sur ce numéro que nous ne communiquerons à personne.","email_info":"Cet email sera votre identifiant pour gérer votre profil.","password":"Votre mot de passe","password_confirmation":"Confirmation de votre mot de passe","structure_name":"Nom de votre structure","structure_name_info":"Si vous êtes un professeur indépendant, renseignez votre Prénom + Nom","structure_address":"Adresse principale","structure_address_info":"Si vous êtes un professeur indépendant, renseignez votre adresse ; si ce n’est pas celle de vos cours, vous pourrez le spécifier dans votre espace et rajouter d’autres lieux","sign_up":"S'inscrire"}},"sessions":{"new":{"log_in":"Connectez-vous à votre espace admin"}}},"courses":{"form":{"type":"Type de cours","individual_course":"Cours","subjects":"Disciplines","audiences":"Public","levels":"Niveaux","info":"Accroche / Libellé du cours","description":"Description du cours","cant_be_joined_during_year":"Ne peut être rejoint en cours d'année","is_for_handicaped":"Cours accessible aux handicapés","name":"Nom du cours","frequency":"Fréquence des cours"}},"places":{"form":{"name":"Nom du lieu","street":"Adresse (N° + rue)","zip_code":"Code postal"}},"plannings":{"form":{"date":"Date"},"workshop_form":{"room":"dans la salle"},"training_form":{"room":"dans la salle"},"index":{"frequency":"Récurrence"}},"structures":{"create":{"create_teacher":"Super ! Renseignez maintenant les professeurs de votre établissement."},"form":{"phone_number_info":"Renseignez au moins un numéro de téléphone :","mobile_phone_number_info":"Pour chaque réservation, un SMS de confirmation pourra être envoyé sur ce numéro","email_info":"Cet email sera votre identifiant pour gérer votre profil.","password_info":"Laissez vide si vous ne voulez pas changer le mot de passe","password_confirmation":"Confirmation de votre mot de passe","structure_name":"Nom de votre structure","structure_name_info":"Si vous êtes un professeur indépendant, renseignez votre Prénom + Nom","structure_address":"Adresse principale (N° + Rue)","structure_address_info":"Si vous êtes un professeur indépendant, renseignez votre adresse ; si ce n’est pas celle de vos cours, vous pourrez le spécifier dans votre espace et rajouter d’autres lieux","management_software_used":"Utilisez vous actuellement un logiciel de gestion ? Si oui, lequel ?"},"new":{"structure_name":"Nom de l'établissement","create_structure":"Créer mon établissement","name":"Nom (Prénom + Nom si vous êtes indépendant","you_are":"Vous êtes ?","contact":"Contact (il est important que l'on puisse vous contacter rapidement)","possible_funding":"Pour l’un ou l’ensemble de vos cours, acceptez-vous le paiement par les financements suivants :","structure_name_info":"Si vous êtes un professeur indépendant, renseignez votre Prénom + Nom","structure_address_info":"Si vous êtes un professeur indépendant, renseignez votre adresse ; si ce n’est pas celle de vos cours, vous pourrez le spécifier dans votre espace et rajouter d’autres lieux","structure_address":"Adresse principale (N° + Rue)"}}},"devise":{"failure":{"pro_admin":{"not_found_in_database":"Utilisateur inconnu"},"already_authenticated":"Vous êtes déjà connecté.","unauthenticated":"Vous devez vous connecter ou vous inscrire pour continuer.","unconfirmed":"Vous devez valider votre inscription pour continuer","locked":"Votre compte est verrouillé.","invalid":"Mauvais email ou mot de passe.","invalid_token":"Jeton d'authentification incorrect.","timeout":"Votre session a expiré.","inactive":"Votre compte n'est pas encore activé.","not_found_in_database":"Mauvais email ou mot de passe."},"sessions":{"signed_in":"Vous êtes bien connecté.","signed_out":"Vous êtes bien déconnecté."},"passwords":{"send_instructions":"Vous allez recevoir les instructions de réinitialisation du mot de passe dans quelques instants","updated":"Votre mot de passe a été édité avec succès, vous êtes maintenant connecté","updated_not_active":"Votre mot de passe a été changé avec succès.","send_paranoid_instructions":"Si votre e-mail existe dans notre base de données, vous allez recevoir un lien de réinitialisation par e-mail","no_token":"Vous ne pouvez accéder à cette page sans passer par un e-mail de réinitialisation de mot de passe. Si vous êtes passé par un e-mail de ce type, assurez-vous d'utiliser l'URL complète."},"confirmations":{"send_instructions":"Vous allez recevoir les instructions nécessaires à la confirmation de votre compte dans quelques minutes","send_paranoid_instructions":"Si votre e-mail existe dans notre base de données, vous allez bientôt recevoir un e-mail contenant les instructions de confirmation de votre compte.","confirmed":"Votre inscription a été validée, vous êtes maintenant connecté"},"registrations":{"signed_up":"Bienvenu, vous êtes connecté","signed_up_but_unconfirmed":"Un message contenant un lien de confirmation a été envoyé à votre adresse email. Ouvrez ce lien pour activer votre compte.","signed_up_but_inactive":"Vous êtes bien enregistré. Vous ne pouvez cependant pas vous connecter car votre compte n'est pas encore activé.","signed_up_but_locked":"Vous êtes bien enregistré. Vous ne pouvez cependant pas vous connecter car votre compte est verrouillé.","updated":"Votre compte a été modifié avec succès.","update_needs_confirmation":"Votre compte a bien été mis à jour mais nous devons vérifier votre nouvelle adresse email. Merci de vérifier vos emails et de cliquer sur le lien de confirmation pour finaliser la validation de votre nouvelle adresse.","destroyed":"Votre compte a été supprimé avec succès. Nous espérons vous revoir bientôt."},"unlocks":{"send_instructions":"Vous allez recevoir les instructions nécessaires au déverrouillage de votre compte dans quelques instants","unlocked":"Votre compte a été déverrouillé avec succès, vous êtes maintenant connecté.","send_paranoid_instructions":"Si votre compte existe, vous allez bientôt recevoir un email contenant les instructions pour le déverrouiller."},"omniauth_callbacks":{"success":"Authentifié avec succès via %{kind}.","failure":"Nous n'avons pas pu vous authentifier via %{kind} : '%{reason}'."},"mailer":{"confirmation_instructions":{"subject":"Validez votre inscription"},"reset_password_instructions":{"subject":"Instructions pour changer le mot de passe"},"unlock_instructions":{"subject":"Instructions pour déverrouiller le compte"},"invitation_instructions":{"subject":"Instructions d'invitation"}},"invitations":{"send_instructions":"Un email d'invitation vient d'être envoyé à l'adresse : %{email}.","invitation_token_invalid":"Le jeton d'invitation n'est pas valide.","updated":"Votre mot de passe a correctement été enregistré. Vous êtes maintenant connecté.","no_invitations_remaining":"Aucune invitation restante","new":{"header":"Envoyer l'invitation","submit_button":"Envoyer une invitation"},"edit":{"header":"Choisissez votre mot de passe","submit_button":"Valider"}}},"admins":{"registration":{"successful":"Merci de vous être enregistré ! Bienvenue dans votre espace de configuration."},"sessions":{"new":{"log_in":"Connectez-vous à votre espace admin"}}},"audience":{"all":"Tout public","kid":"Enfant","teenage":"Ado","adult":"Adulte","senior":"Sénior"},"unauthorized":{"manage":{"all":"Vous n'êtes pas autorisé à %{action} %{subject}.","structure":"Vous n'êtes pas autorisé à gérer la structure d'autres utilisateurs"},"update":{"all":"Vous n'êtes pas autorisé à %{action} %{subject}."}},"book_tickets":{"book_ticket":{"libelle":{"zero":"Carnet de zero ticket","one":"Carnet de un ticket","other":"Carnet de %{count} tickets"},"validity":{"zero":"Non valide","one":"Valide un mois","other":"Valide %{count} mois"}}},"comments":{"deletion_reasons":{"duplicate":"Avis en doublon","misspellings":"Fautes d'orthographes","inapropriate_content":"Contenu inapproprié / offensant","other":"Autres"},"errors":{"already_posted":"Vous avez déjà posté un avis sur cet établissement."}},"all_subject":"Toutes les disciplines","courses":{"training":{"day_schedule":"%{day} à %{start_time} (%{duration})"},"frequencies":{"every_week":"Toutes les semaines","every_two_weeks":"Tous les 15 jours","every_month":"Tous les mois"},"description_tab":{"course_description":"Description du cours :","more_information":"Informations complémentaires :","no_information":"Pas d'information pour ce cours"},"planning_tab":{"collective":"Collectif","infos":"Infos","teacher":"Professeur","course":"Cours","min_age_for_kid":"Age min","max_age_for_kid":"Age max","class_during_holidays":"Cours pendant les vacances","audience":"Public","cant_be_joined_during_year":"Ne peut être rejoint en cours d’année"},"course":{"from":"À partir de"}},"structures":{"courses":{"price_tab":{"price":"Prix","holiday_vouchers":"Chèques Vacances","sport_coupons":"Coupons Sports ANCV","leisure_coupons":"Tickets Loisirs C.A.F. (y compris les \"Tickets Temps Libres\")","afdas_html":"AFDAS ( \u003Ca target='_blank' href='https://www.afdas.com/'\u003Eplus d'infos\u003C/a\u003E )","dif_html":"DIF ( \u003Ca target='_blank' href='http://travail-emploi.gouv.fr/le-droit-individuel-a-la-formation,1071.html'\u003Eplus d'infos\u003C/a\u003E )","cif_html":"CIF ( \u003Ca target='_blank' href='http://travail-emploi.gouv.fr/informations-pratiques,89/fiches-pratiques,91/formation-professionnelle,118/le-conge-individuel-de-formation,1070.html'\u003Eplus d'infos\u003C/a\u003E )","possible_funding":"Moyen de financements possible :","formule_type":"Type de formule","without_promo":"Sans promo","with_promo":"Avec promo","infos":"Infos tarifaire spécifique à %{place_name}"},"comments":{"post_your_opinion":"Donnez nous votre avis sur ce %{course_type_name}","last_students_opinion":"Avis des élèves précédents"},"show":{"back_to_search":"Retour à la recherche","planning":"Planning","prices":"Tarifs","infos":"Infos","structure":"Établissement","opinions":"Avis","back_to_structure":"Retour à l'établissement","back_to_results":"Retour aux résultats","see_arrounding_courses":"Voir les cours à proximité"}},"accepted_image_formats":"Formats autorisés : JPEG / JPG / GIF / PNG / BMP- Taille maximum 5mo","company":"École privée","association":"Association","other":"Autre","board":"Autre","independant":"Professeur indépendant","cancel_conditions":{"flexible":"Flexibles : remboursement intégral jusqu’à la veille du cours","moderate":"Modérées : remboursement intégral jusqu’à 3 jours avant la date du cours","strict":"Strictes : 50% remboursé jusqu’à 1 semaine avant la date du cours","very_strict":"Très strictes : pas d’annulation ni de remboursement possible"},"modification_conditions":{"flexible":"Flexibles : possibilité de changer de séance (pour un même cours au même tarif) jusqu’à la veille du cours","moderate":"Modérées : possibilité de changer de séance (pour un même cours au même tarif) jusqu’à 1 semaine avant la date du cours","strict":"Strictes : pas de modification possible"},"show":{"see_arrounding_structures":"Voir les établissements à proximité","back_to_results":"Retour aux résultats"},"widget_status":{"installed":"Oui, je l'ai déjà installé","remind_me":"Me le rappeler plus tard","dont_want":"Non, je n'en veux pas","need_help":"Non, j'ai besoin d'aide"}},"errors":{"messages":{"expired":"a expiré, merci d'en faire une nouvelle demande","not_found":"n'a pas été trouvé(e)","already_confirmed":"a déjà été validé(e)","not_locked":"n'était pas verrouillé(e)","not_saved":{"one":"1 erreur a empêché ce(tte) %{resource} d'être sauvegardé(e) :","other":"%{count} erreurs ont empêché ce(tte) %{resource} d'être sauvegardé(e) :"},"inclusion":"n'est pas inclus(e) dans la liste","exclusion":"n'est pas disponible","invalid":"n'est pas valide","confirmation":"ne concorde pas avec la confirmation","accepted":"doit être accepté(e)","empty":"doit être rempli(e)","blank":"doit être rempli(e)","too_long":{"one":"est trop long (pas plus d'un caractère)","other":"est trop long (pas plus de %{count} caractères)"},"too_short":{"one":"est trop court (au moins un caractère)","other":"est trop court (au moins %{count} caractères)"},"wrong_length":{"one":"ne fait pas la bonne longueur (doit comporter un seul caractère)","other":"ne fait pas la bonne longueur (doit comporter %{count} caractères)"},"not_a_number":"n'est pas un nombre","not_an_integer":"doit être un nombre entier","greater_than":"doit être supérieur à %{count}","greater_than_or_equal_to":"doit être supérieur ou égal à %{count}","equal_to":"doit être égal à %{count}","less_than":"doit être inférieur à %{count}","less_than_or_equal_to":"doit être inférieur ou égal à %{count}","odd":"doit être impair","even":"doit être pair","taken":"n'est pas disponible","record_invalid":"La validation a échoué : %{errors}"},"format":"%{attribute} %{message}","template":{"header":{"one":"Impossible d'enregistrer ce(tte) %{model} : 1 erreur","other":"Impossible d'enregistrer ce(tte) %{model} : %{count} erreurs"},"body":"Veuillez vérifier les champs suivants : "}},"yes":"Oui","no":"Non","date":{"formats":{"default":"%d/%m/%Y","short":"%e %b","semi_short":"%e %B","semi_long":"%A %e %B","long":"%e %B %Y"},"day_names":["dimanche","lundi","mardi","mercredi","jeudi","vendredi","samedi"],"abbr_day_names":["dim","lun","mar","mer","jeu","ven","sam"],"month_names":[null,"janvier","février","mars","avril","mai","juin","juillet","août","septembre","octobre","novembre","décembre"],"abbr_month_names":[null,"jan.","fév.","mar.","avr.","mai","juin","juil.","août","sept.","oct.","nov.","déc."],"order":["day","month","year"]},"time":{"formats":{"default":"%d %B %Y %H:%M:%S","short":"%Hh%M","long":"%A %d %B %Y %H:%M","date":"%A %d %B","date_short":"%d/%m/%Y","date_short_en":"%Y-%m-%d","iso_date":"%Y-%m-%d"},"am":"am","pm":"pm"},"datetime":{"distance_in_words":{"half_a_minute":"une demi-minute","less_than_x_seconds":{"zero":"moins d'une seconde","one":"moins d'une seconde","other":"moins de %{count} secondes"},"x_seconds":{"one":"1 seconde","other":"%{count} secondes"},"less_than_x_minutes":{"zero":"moins d'une minute","one":"moins d'une minute","other":"moins de %{count} minutes"},"x_minutes":{"one":"1 minute","other":"%{count} minutes"},"about_x_hours":{"one":"environ une heure","other":"environ %{count} heures"},"x_days":{"one":"1 jour","other":"%{count} jours"},"about_x_months":{"one":"environ un mois","other":"environ %{count} mois"},"x_months":{"one":"1 mois","other":"%{count} mois"},"about_x_years":{"one":"environ un an","other":"environ %{count} ans"},"over_x_years":{"one":"plus d'un an","other":"plus de %{count} ans"},"almost_x_years":{"one":"presqu'un an","other":"presque %{count} ans"}},"prompts":{"year":"Année","month":"Mois","day":"Jour","hour":"Heure","minute":"Minute","second":"Seconde"}},"number":{"ordinals":{"\\A(1)\\z":"%dère","\\A(2)\\z":"%dème","other":"%dème"},"format":{"separator":",","delimiter":" ","precision":2,"significant":false,"strip_insignificant_zeros":false},"currency":{"format":{"format":"%n %u","unit":"€","separator":",","delimiter":" ","precision":2,"significant":false,"strip_insignificant_zeros":false}},"percentage":{"format":{"delimiter":""}},"precision":{"format":{"delimiter":""}},"human":{"format":{"delimiter":"","precision":2,"significant":true,"strip_insignificant_zeros":true},"storage_units":{"format":"%n %u","units":{"byte":{"one":"octet","other":"octets"},"kb":"ko","mb":"Mo","gb":"Go","tb":"To"}},"decimal_units":{"format":"%n %u","units":{"unit":"","thousand":"millier","million":"million","billion":"milliard","trillion":"billion","quadrillion":"million de milliards"}}}},"support":{"array":{"words_connector":", ","two_words_connector":" et ","last_word_connector":" et "}},"helpers":{"page_entries_info":{"one_page":{"display_entries":{"zero":"Pas de résultat.","one":"\u003Cb\u003E1\u003C/b\u003E %{entry_name} trouvé","other":"\u003Cb\u003E%{count}\u003C/b\u003E %{entry_name} trouvés"}},"more_pages":{"display_entries":"Résultat : %{first}\u0026nbsp;-\u0026nbsp;%{last} sur \u003Cb\u003E%{total}\u003C/b\u003E %{entry_name}"}}},"activemodel":{"errors":{"format":"%{attribute} %{message}","messages":{"inclusion":"n'est pas inclus(e) dans la liste","exclusion":"n'est pas disponible","invalid":"n'est pas valide","confirmation":"ne concorde pas avec la confirmation","accepted":"doit être accepté(e)","empty":"doit être rempli(e)","blank":"doit être rempli(e)","too_long":{"one":"est trop long (pas plus d'un caractère)","other":"est trop long (pas plus de %{count} caractères)"},"too_short":{"one":"est trop court (au moins un caractère)","other":"est trop court (au moins %{count} caractères)"},"wrong_length":{"one":"ne fait pas la bonne longueur (doit comporter un seul caractère)","other":"ne fait pas la bonne longueur (doit comporter %{count} caractères)"},"not_a_number":"n'est pas un nombre","not_an_integer":"doit être un nombre entier","greater_than":"doit être supérieur à %{count}","greater_than_or_equal_to":"doit être supérieur ou égal à %{count}","equal_to":"doit être égal à %{count}","less_than":"doit être inférieur à %{count}","less_than_or_equal_to":"doit être inférieur ou égal à %{count}","odd":"doit être impair","even":"doit être pair","taken":"n'est pas disponible","record_invalid":"La validation a échoué : %{errors}"},"template":{"header":{"one":"Impossible d'enregistrer ce(tte) %{model} : 1 erreur","other":"Impossible d'enregistrer ce(tte) %{model} : %{count} erreurs"},"body":"Veuillez vérifier les champs suivants : "}}},"views":{"pagination":{"truncate":"...","first":"Début","previous":"\u003Ci class='icon-arrow-left'\u003E\u003C/i\u003E","next":"\u003Ci class='icon-arrow-right'\u003E\u003C/i\u003E","last":"Fin"}},"will_paginate":{"page_gap":"...","previous_label":"Précedent","next_label":"Suivant","page_entries_info":{"single_page":{"zero":"Aucun résultat ne correspondant à votre recherche.","one":"Résultat : 1","other":"Résultat : %{count}"},"single_page_html":{"zero":"Aucun résultat ne correspondant à votre recherche.","one":"Résultat : 1","other":"Résultat : %{count}"},"multi_page_html":"Résultat : %{from} à %{to} sur %{count} cours","multi_page":"Résultat : %{from} à %{to} sur %{count} cours"}},"home":{"index":{"validate":"Valider"}},"level":{"all":"Tous niveaux","initiation":"Initiation","beginner":"Débutant","intermediate":"Moyen","confirmed":"Avancé","professional":"Professionnel"},"planning":{"no_duration":"Pas de durée","levels":"Niveau(x)","audiences":"Public(s)"},"prices":{"free":"Gratuit","contact_structure":"Contacter l'établissement","individual_course":"1 cours","registration_fees":"Frais d'adhésion","book_ticket":{"libelle":{"zero":"Carnet de zero ticket","one":"Carnet de un ticket","other":"Carnet de %{count} tickets"}},"subscription":{"annual":"Abonnement annuel","semester":"Abonnement semestriel","trimester":"Abonnement trimestriel","month":"Abonnement mensuel"},"discount":{"student":"Étudiant","young_and_senior":"Jeune et sénior","job_seeker":"Demandeur d'emploi","low_income":"Revenu faible","large_family":"Famille nombreuse","couple":"Couple","training":"Prix du stage","trial_lesson":"Cours d'essai","other":"Autres"}},"rooms":{"main_room":"Salle principale"},"simple_form":{"yes":"Oui","no":"Non","required":{"text":"requis","mark":"*","html":"\u003Cabbr title=\"Champ obligatoire\"\u003E*\u003C/abbr\u003E"},"error_notification":{"default_message":"Veuillez vérifier les problèmes ci-dessous :"}},"funding_type":{"holiday_vouchers":"Tickets CAF (\"loisirs\" et \"temps libre\")","ancv_sports_coupon":"Coupon Sports ANCV","leisure_tickets":"Chèques vacances","afdas":"AFDAS","dif":"DIF","cif":"CIF","cesu":"CESU","culture_cheque":"Chèques Culture","restaurant_ticket":"Tickets restaurant"},"students":{"email":"E-mail","city":"Ville","wrong_email":"Votre email n'est pas valide","creation_success_notice":"Merci de nous avoir laisser votre email, nous vous recontacterons au plus vite !"}}};
