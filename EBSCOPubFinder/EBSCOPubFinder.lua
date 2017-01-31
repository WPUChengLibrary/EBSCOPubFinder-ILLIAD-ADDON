-- About EBSCOPubFinder.lua 
-- does a ISSN search for articles.
-- if not ISSN field, search PhotoJournalTitle instead.
-- autoSearch (boolean) determines whether the search is performed automatically when a request is opened or not.

local settings = {};
settings.AutoSearch = GetSetting("AutoSearch");

local EBSCOPubFinderURL = GetSetting("EBSCOPubFinderURL");
local interfaceMngr = nil;
local pubfinderSearchForm = {};
pubfinderSearchForm.Form = nil;
pubfinderSearchForm.Browser = nil;
pubfinderSearchForm.RibbonPage = nil;

require "Atlas.AtlasHelpers";

function Init()
	if GetFieldValue("Transaction", "RequestType") == "Article" then
		interfaceMngr = GetInterfaceManager();
		
		-- Create a form
		pubfinderSearchForm.Form = interfaceMngr:CreateForm("EBSCOPubFinder", "Script");
		
		-- Add a browser
		pubfinderSearchForm.Browser = pubfinderSearchForm.Form:CreateBrowser("EBSCOPubFinder", "EBSCOPubFinder Browser", "EBSCOPubFinder");
		
		-- Hide the text label
		pubfinderSearchForm.Browser.TextVisible = false;
		
		-- Since we didn't create a ribbon explicitly before creating our browser, it will have created one using the name we passed the CreateBrowser method.  We can retrieve that one and add our buttons to it.
		pubfinderSearchForm.RibbonPage = pubfinderSearchForm.Form:GetRibbonPage("EBSCOPubFinder");
		
		-- Create the search button
		pubfinderSearchForm.RibbonPage:CreateButton("Search", GetClientImage("Search32"), "Search", "ISSN");
		
		-- After we add all of our buttons and form elements, we can show the form.
		pubfinderSearchForm.Form:Show();
		
		if settings.AutoSearch then
			Search();
		end
	end
end

function Search()
	if GetFieldValue("Transaction", "ISSN") ~= "" then
	 pubfinderSearchForm.Browser:Navigate(EBSCOPubFinderURL .. AtlasHelpers.UrlEncode(GetFieldValue("Transaction", "ISSN")));	
	else
     pubfinderSearchForm.Browser:Navigate(EBSCOPubFinderURL .. AtlasHelpers.UrlEncode(GetFieldValue("Transaction", "PhotoJournalTitle")));	
	end
end



