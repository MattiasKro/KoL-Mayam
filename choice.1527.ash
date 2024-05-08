import "relay/choice.ash";
import "relay/MayamCalendarRelay.ash";

//Choice	override

void main(string page_text_encoded)
{
	string page_text = page_text_encoded.choiceOverrideDecodePageText();
    string newPage = handleYamConsideration(page_text); 

    newPage.write();	
}