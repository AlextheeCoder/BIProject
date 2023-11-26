<!DOCTYPE html>
<html>
<head>
    <title>Startup Success Prediction</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h2>Startup Success Predictor</h2>
    <form action="api.php" method="get">
        <label for="funding_total_usd">Total Funding (USD):</label><br>
        <input type="text" id="funding_total_usd" name="funding_total_usd" value=""><br><br>

        <label for="funding_rounds">Funding Rounds:</label><br>
        <input type="text" id="funding_rounds" name="funding_rounds" value=""><br><br>

        <label for="milestones">Milestones:</label><br>
        <input type="text" id="milestones" name="milestones" value=""><br><br>

        <label for="category_code">Category Code:</label><br>
        <select id="category_code" name="category_code">
            <!-- Options for Category Code -->
            <?php foreach(["advertising", "analytics", "automotive", "biotech", "cleantech", "consulting", "ecommerce", "education", "enterprise", "fashion", "finance", "games_video", "hardware", "health", "hospitality", "manufacturing", "medical", "messaging", "mobile", "music", "network_hosting", "news", "other", "photo_video", "public_relations", "real_estate", "search", "security", "semiconductor", "social", "software", "sports", "transportation", "travel", "web"] as $code): ?>
                <option value="<?php echo htmlspecialchars($code); ?>"><?php echo htmlspecialchars($code); ?></option>
            <?php endforeach; ?>
        </select><br><br>

        <label for="state">State:</label><br>
        <select id="state" name="state">
            <!-- Options for State -->
            <?php foreach(["California", "Massachusetts", "New York", "Other states", "Texas", "Unknow"] as $state): ?>
                <option value="<?php echo htmlspecialchars($state); ?>"><?php echo htmlspecialchars($state); ?></option>
            <?php endforeach; ?>
        </select><br><br>

        <label for="industry">Industry:</label><br>
        <select id="industry" name="industry">
            <!-- Options for Industry -->
            <?php foreach(["Advertising", "Biotech", "Consulting", "Ecommerce", "Enterprise", "Mobile", "Other Category", "Software", "Video Games", "Web"] as $industry): ?>
                <option value="<?php echo htmlspecialchars($industry); ?>"><?php echo htmlspecialchars($industry); ?></option>
            <?php endforeach; ?>
        </select><br><br>

        <input type="submit" value="Predict">
    </form>
</body>
</html>
