public class Equipment {

	public String x_id {get;set;} // in json: _id
	public Boolean replacement {get;set;} 
	public Integer quantity {get;set;} 
	public String name {get;set;} 
	public Integer maintenanceperiod {get;set;} 
	public Integer lifespan {get;set;} 
	public Integer cost {get;set;} 
	public String sku {get;set;} 

	public Equipment(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == '_id') {
						x_id = parser.getText();
					} else if (text == 'replacement') {
						replacement = parser.getBooleanValue();
					} else if (text == 'quantity') {
						quantity = parser.getIntegerValue();
					} else if (text == 'name') {
						name = parser.getText();
					} else if (text == 'maintenanceperiod') {
						maintenanceperiod = parser.getIntegerValue();
					} else if (text == 'lifespan') {
						lifespan = parser.getIntegerValue();
					} else if (text == 'cost') {
						cost = parser.getIntegerValue();
					} else if (text == 'sku') {
						sku = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'Equipment consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static List<Equipment> parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return arrayOfEquipment(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}


    private static List<Equipment> arrayOfEquipment(System.JSONParser p) {
        List<Equipment> res = new List<Equipment>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Equipment(p));
        }
        return res;
    }

	public String getx_id()
	{
		return this.x_id;
	}
}