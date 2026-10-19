import adsk.core,adsk.fusion,json,re
from pathlib import Path

def run(_context: str):
 app=adsk.core.Application.get();d=adsk.fusion.Design.cast(app.activeProduct)
 p=Path(r'C:\Users\mason\Documents\Codex\2026-09-15\i-d\archive-repo\designs\sculpture-lamp\cad-v2')
 info=json.loads((p/'form-study.json').read_text());data={a['id']:a for a in json.loads((p/'fusion-body-input.json').read_text())}
 lib=app.materialLibraries.itemById('BA5EE55E-9982-449B-9D66-9F036540E140');template=lib.appearances.itemByName('Plastic - Matte (Black)')
 colors={}
 for name,hexval in info['palette'].items():
  appearance=d.appearances.itemByName('Corgi '+name)
  if not appearance:appearance=d.appearances.addByCopy(template,'Corgi '+name)
  rgb=[int(hexval[i:i+2],16) for i in (1,3,5)]
  for propid in ['opaque_albedo','surface_albedo']:
   prop=adsk.core.ColorProperty.cast(appearance.appearanceProperties.itemById(propid))
   prop.value=adsk.core.Color.create(*rgb,255)
  colors[name]=appearance
 report=[]
 for b in d.rootComponent.bRepBodies:
  key=re.sub(r' \(\d+\)$','',b.name)
  expected=data[key]['expected_volume_mm3'];actual=b.volume*1000
  assert b.isSolid and actual>0 and abs(actual-expected)/expected<.001,key
  b.appearance=colors[data[key]['color']]
  report.append(dict(id=key,isSolid=b.isSolid,volume_mm3=actual,relative_volume_error=abs(actual-expected)/expected))
 assert len(report)==len(data) and len({x['id'] for x in report})==len(data)
 (p/'fusion-validation.json').write_text(json.dumps(dict(parts=report,status='Appearance review only; not slice or fit verified'),indent=2))
 cam=app.activeViewport.camera;cam.eye=adsk.core.Point3D.create(-38,-70,26);cam.target=adsk.core.Point3D.create(0,0,14);cam.upVector=adsk.core.Vector3D.create(0,0,1);cam.cameraType=adsk.core.CameraTypes.OrthographicCameraType;cam.isFitView=True;cam.isSmoothTransition=False;app.activeViewport.camera=cam
 assert app.activeViewport.saveAsImageFile(str(p/'fusion-front.png'),1400,1400)
 for opts in [d.exportManager.createFusionArchiveExportOptions(str(p/'corgi-form-revision-v2.f3d')),d.exportManager.createSTEPExportOptions(str(p/'corgi-form-revision-v2.step'))]:
  assert d.exportManager.execute(opts)
 print('Verified and exported',len(report),'native solids; maximum relative volume error',max(x['relative_volume_error'] for x in report))
