
## Examples of documents

Back to [home](../README.md)

### HGB_1_002_046_035

Aescher Vorstadt 37

![Card HGB_1_002_046_035](https://files.transkribus.eu/Get?id=HBCPOPWZFLWVMKESTUUAIYQQ)

Peter Schorch der Schuemacher contra Friedrich Reinen , Spitthalkiefer , als Vogt Jacob Schwartzen des Küfers sel . Kinder in Eschemervorstatt , betr . einem Känell , dadurch dem Kläger das Wasser in seinen Privaten dringet wegen einem Camin .

------

<spans>
    <span id="691" start="0" end="3" text="Peter Schorch der Schuemacher" element="reference" class="per" numerus="sgl" specificity="spc" tense="pres" polarity="pos" modality="ass" subclass="">
      <span id="697" start="0" end="1" text="Peter Schorch" element="head" class="nam" subclass=""/>
      <span id="703" start="2" end="3" text="der Schuemacher" element="appo" class="occ" numerus="sgl" specificity="spc" tense="pres" polarity="pos" modality="ass" subclass="">
        <span id="709" start="3" end="3" text="Schuemacher" element="head" class="occ" subclass=""/>
      </span>
    </span>
    <span id="830" start="4" end="4" text="contra" element="trigger" class="litigation" tense="pres" polarity="pos" modality="ass" subclass=""/>
    <span id="721" start="5" end="8" text="Friedrich&#10;Reinen , Spitthalkiefer" element="reference" class="per" numerus="sgl" specificity="spc" tense="pres" polarity="pos" modality="ass" subclass="">
      <span id="727" start="5" end="6" text="Friedrich&#10;Reinen" element="head" class="nam" subclass=""/>
      <span id="733" start="8" end="8" text="Spitthalkiefer" element="appo" class="occ" numerus="sgl" specificity="spc" tense="pres" polarity="pos" modality="ass" subclass="org-job">
        <span id="733_head" start="8" end="8" element="head" class="occ" text="Spitthalkiefer" subclass="org-job"/>
      </span>
    </span>
    <span id="739" start="11" end="20" text="Vogt Jacob Schwartzen&#10;des Küfers sel . Kinder in Eschemervorstatt" element="reference" class="per" numerus="sgl" specificity="spc" tense="pres" polarity="pos" modality="ass" subclass="">
      <span id="745" start="11" end="11" text="Vogt" element="head" class="repr" subclass=""/>
      <span id="818" start="12" end="20" text="Jacob Schwartzen&#10;des Küfers sel . Kinder in Eschemervorstatt" element="reference" class="per" numerus="grp" specificity="spc" tense="pres" polarity="pos" modality="ass" subclass="">
        <span id="757" start="12" end="17" text="Jacob Schwartzen&#10;des Küfers sel ." element="reference" class="per" numerus="sgl" specificity="spc" tense="pres" polarity="pos" modality="ass" subclass="">
          <span id="751" start="12" end="13" text="Jacob Schwartzen" element="head" class="nam" subclass=""/>
          <span id="763" start="14" end="15" text="des Küfers" element="appo" class="occ" numerus="sgl" specificity="spc" tense="pres" polarity="pos" modality="ass" subclass="">
            <span id="769" start="15" end="15" text="Küfers" element="head" class="occ" subclass=""/>
          </span>
          <span id="824" start="16" end="17" text="sel ." element="attr" class="dead" numerus="sgl" specificity="spc" tense="pres" polarity="pos" modality="ass" subclass=""/>
        </span>
        <span id="775" start="18" end="18" text="Kinder" element="head" class="fam" subclass=""/>
        <span id="781" start="19" end="20" text="in Eschemervorstatt" element="attr" class="loc" numerus="sgl" specificity="spc" tense="pres" polarity="pos" modality="ass" subclass="">
          <span id="793" start="20" end="20" text="Eschemervorstatt" element="reference" class="fac" numerus="sgl" specificity="spc" tense="pres" polarity="pos" modality="ass" subclass="district">
            <span id="787" start="20" end="20" text="Eschemervorstatt" element="head" class="nam" subclass=""/>
          </span>
        </span>
      </span>
    </span>
    <span id="836" start="24" end="38" text="einem Känell , dadurch dem Kläger das Wasser&#10;in seinen Privaten dringet wegen einem Camin" element="other" class="other" subclass="">
      <span id="799" start="28" end="29" text="dem Kläger" element="reference" class="per" numerus="sgl" specificity="spc" tense="pres" polarity="pos" modality="ass" subclass="">
        <span id="805" start="29" end="29" text="Kläger" element="head" class="role" subclass=""/>
      </span>
    </span>
  </spans>

-----
    <eventGroups>
        <eventGroup event_id="0" class="representation" polarity="pos" tense="pres" modality="ass" start="11" end="20" ref="739" type="state">
        <trigger start="11" end="11" text="Vogt" ref="745"/>
        <event event_id="0.0">
            <role role="representative" ref="739" text="Vogt Jacob Schwartzen&#10;des Küfers sel . Kinder in Eschemervorstatt"/>
            <role role="represented" ref="818" text="Jacob Schwartzen&#10;des Küfers sel . Kinder in Eschemervorstatt"/>
        </event>
        </eventGroup>
        <eventGroup event_id="1" class="family" polarity="pos" tense="pres" modality="ass" start="12" end="20" ref="818" type="state">
        <trigger start="18" end="18" text="Kinder" ref="775"/>
        <event event_id="1.0">
            <role role="family-a" ref="818" text="Jacob Schwartzen&#10;des Küfers sel . Kinder in Eschemervorstatt"/>
            <role role="family-b" ref="757" text="Jacob Schwartzen&#10;des Küfers sel ."/>
        </event>
        </eventGroup>
        <eventGroup event_id="2" class="topological" polarity="pos" tense="pres" modality="ass" start="19" end="20" ref="781" type="state">
        <event event_id="2.0">
            <role role="location-a" ref="818" text="Jacob Schwartzen&#10;des Küfers sel . Kinder in Eschemervorstatt"/>
            <role role="location-b" ref="793" text="Eschemervorstatt"/>
        </event>
        </eventGroup>
        <eventGroup event_id="3" class="litigation" polarity="pos" tense="pres" modality="ass" start="0" end="4" ref="" type="event">
        <trigger start="4" end="4" text="contra" ref="830"/>
        <event event_id="3.0">
            <role role="party1" ref="691" text="Peter Schorch der Schuemacher"/>
            <role role="party2" ref="721" text="Friedrich&#10;Reinen , Spitthalkiefer"/>
            <role role="subject" ref="836" text="einem Känell , dadurch dem Kläger das Wasser&#10;in seinen Privaten dringet wegen einem Camin"/>
        </event>
        </eventGroup>
    </eventGroups>

-----    


### Links to archive

* [Aeschenvorstadt 9 HGB 1 2/26](https://dls.staatsarchiv.bs.ch/records/1432499/2640666/preview?context=%2Fsearch%3Fpage%3D1%26page_size%3D25%26query%3DHGB%25201%25202%252F26%26advanced_query%3Dfalse&viewer_page=1)

* [Aeschenvorstadt 37 HGB 1 2/46](https://dls.staatsarchiv.bs.ch/records/1432847/2640698/preview?context=%2Frecords%2F1432847&viewer_page=3)
